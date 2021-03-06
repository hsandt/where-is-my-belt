#!/bin/bash

# Build a specific cartridge for the game
# It relies on pico-boots/scripts/build_cartridge.sh
# It also defines game information and defined symbols per config.

# Configuration: paths
picoboots_scripts_path="$(dirname "$0")/pico-boots/scripts"
game_prebuild_path="$(dirname "$0")/prebuild"
game_src_path="$(dirname "$0")/src"
data_path="$(dirname "$0")/data"
build_dir_path="$(dirname "$0")/build"

# Configuration: cartridge
author=`cat "$data_path/author_pico8.txt"`
title_pico8=`cat "$data_path/title_pico8.txt"`
cartridge_stem=`cat "$data_path/title_cartridge.txt"`
version=`cat "$data_path/version.txt"`
use_cartridge_full_suffix_in_title=false  # for a 1-cartridge game, we recommend false

# Configuration: numerical data modules
# Define list of data module paths, separated by space (Python argparse nargs='*')
# to allow constant substitution
# Ex: game_constant_module_paths_string="${game_src_path}/data/numerical_data.lua"
game_constant_module_paths_string="${game_src_path}/data/sprite_flags.lua \
${game_src_path}/data/ingame_numerical_data.lua \
${game_src_path}/ingame/ingame_phase.lua \
${game_src_path}/ingame/failure_reason.lua \
${game_src_path}/resources/audio.lua \
${game_src_path}/resources/memory.lua \
"

help() {
  echo "Build a PICO-8 cartridge with the passed config."
  usage
}

usage() {
  echo "Usage: build_single_cartridge.sh CARTRIDGE_SUFFIX [CONFIG] [OPTIONS]

ARGUMENTS
  CARTRIDGE_SUFFIX          Cartridge to build for the multi-cartridge game
                            See data/cartridges.txt for the list of cartridge names
                            A symbol equal to the cartridge suffix is always added
                            to the config symbols.

  CONFIG                    Build config. Determines defined preprocess symbols.
                            (default: 'debug')

  -i, --itest               Pass this option to build an itest instead of a normal game cartridge.

  -h, --help                Show this help message
"
}

# Default parameters
config='debug'
itest=false

# Read arguments
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
while [[ $# -gt 0 ]]; do
  case $1 in
    -i | --itest )
      itest=true
      shift # past argument
      ;;
    -h | --help )
      help
      exit 0
      ;;
    -* )    # unknown option
      echo "Unknown option: '$1'"
      usage
      exit 1
      ;;
    * )     # store positional argument for later
      positional_args+=("$1")
      shift # past argument
      ;;
  esac
done

if ! [[ ${#positional_args[@]} -ge 1 && ${#positional_args[@]} -le 2 ]]; then
  echo "Wrong number of positional arguments: found ${#positional_args[@]}, expected 1 or 2."
  echo "Passed positional arguments: ${positional_args[@]}"
  usage
  exit 1
fi

if [[ ${#positional_args[@]} -ge 1 ]]; then
  cartridge_suffix="${positional_args[0]}"
fi

if [[ ${#positional_args[@]} -ge 2 ]]; then
  config="${positional_args[1]}"
fi

# itest cartridges enforce special config 'itest' and ignore passed config
if [[ "$itest" == true ]]; then
  config='itest'
fi

# Define build output folder from config
# (to simplify cartridge loading, cartridge files are always named the same,
#  so we can only distinguish builds by their folder names)
build_output_path="${build_dir_path}/v${version}_${config}"

# Define symbols from config
symbols=''

if [[ $config == 'debug' ]]; then
  symbols='assert,tostring,log,visual_logger,tuner,mouse,debug_menu,cheat'
elif [[ $config == 'debug-ultrafast' ]]; then
  symbols='assert,tostring,dump,log,cheat,ultrafast'
elif [[ $config == 'cheat' ]]; then
  symbols='cheat,tostring,dump,log,debug_menu'
elif [[ $config == 'tuner' ]]; then
  symbols='tuner,mouse'
elif [[ $config == 'ultrafast' ]]; then
  symbols='ultrafast'
elif [[ $config == 'cheat-ultrafast' ]]; then
  symbols='cheat,ultrafast,debug_menu'
elif [[ $config == 'sandbox' ]]; then
  symbols='sandbox,assert,tuner,mouse'
elif [[ $config == 'assert' ]]; then
  symbols='assert,tostring,dump'
elif [[ $config == 'profiler' ]]; then
  symbols='profiler,debug_menu,cheat'
  # if profiler is too heavy, use lightweight version
  # symbols='profiler_lightweight,cheat'
  # if this is still too heavy, just use Ctrl+P for the built-in profiler
elif [[ $config == 'recorder' ]]; then
  symbols='recorder,tostring,log'
elif [[ $config == 'itest' ]]; then
  # cheat needed to set debug motion mode
  symbols='itest,proto,tostring,cheat'
elif [[ $config == 'release' ]]; then
  # usually release has no symbols except those that help making the code more compact
  # in this game project we define 'release' as a special symbol for that
  # most of the time, we could replace `#if release` with
  # `#if debug_option1 || debug_option2 || debug_option3 ` but the problem is that
  # 2+ OR statements syntax is not supported by preprocess.py yet
  symbols='release'
fi

# we always add a symbol for the cartridge suffix in case
#  we want to customize the build of the same script
#  depending on the cartridge it is built into
if [[ -n "$symbols" ]]; then
  # there was at least one symbol before, so add comma separator
  symbols+=","
fi
symbols+="$cartridge_suffix"

# Define builtin data to use based on cartridge suffix
data_filebasename="builtin_data_${cartridge_suffix}"

if [[ "$itest" == true ]]; then
  main_prefix='itest_'
  required_relative_dirpath="itests/${cartridge_suffix}"
  cartridge_extra_suffix='itest_all_'
  # Do NOT unify itest cartridges: they rely on [[add_require]] injection being done
  # after ijecting the app into itest_run, and unification dismantles require order,
  # forgetting exact line positioning and only caring about file dependency order.
  unify_option=''
else
  main_prefix=''
  required_relative_dirpath=''
  cartridge_extra_suffix=''
  unify_option="--unify _${cartridge_suffix}"
fi

cartridge_full_suffix="${cartridge_extra_suffix}${cartridge_suffix}"

if [[ "$use_cartridge_full_suffix_in_title" == true ]]; then
  full_title="$title_pico8 v$version (${cartridge_full_suffix})"
else
  full_title="$title_pico8 v$version"
fi

# Build cartridge
# See data/cartridges.txt for the list of cartridge names
# metadata really counts for the entry cartridge (titlemenu)

# Note about option -o: we build cartridges without version nor config
#  appended to name so we can use PICO-8 load() with a cartridge file name
#  independent from the version and config
"$picoboots_scripts_path/build_cartridge.sh"                          \
  "$game_src_path"                                                    \
  ${main_prefix}main_${cartridge_suffix}.lua                          \
  ${required_relative_dirpath}                                        \
  -d "${data_path}/${data_filebasename}.p8"                           \
  -M "$data_path/metadata.p8"                                         \
  -a "$author" -t "$full_title" \
  -p "$build_output_path"                                             \
  -o "${cartridge_stem}_${cartridge_full_suffix}"                     \
  -c "$config"                                                        \
  --no-append-config                                                  \
  -s "$symbols"                                                       \
  -g "$game_constant_module_paths_string"                             \
  -r "$game_prebuild_path"                                            \
  -v version="$version"                                               \
  --minify-level 3                                                    \
  $unify_option

if [[ $? -ne 0 ]]; then
  echo ""
  echo "Build failed, STOP."
  exit 1
fi
