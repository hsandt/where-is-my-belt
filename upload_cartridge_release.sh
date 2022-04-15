#!/bin/bash

# Update exported cartridge release to itch.io via butler
# Make sure to first build, export and patch game, and also to have pushed a tag for release.
# Travis generates ${BUILD_TITLE}_v${BUILD_VERSION}_release_cartridges.zip containing .p8 files
# for release, but we need pico8 to build _png_cartridges, .bin and _web, so we always
# export those from a local computer.

# Dependencies:
# - butler

# You also need to be signed in on itch.io as a collaborator on this project!

# Configuration: paths
data_path="$(dirname "$0")/data"
# Linux only
carts_dirpath="$HOME/.lexaloffle/pico-8/carts"

# Configuration: cartridge
cartridge_stem=`cat "$data_path/title_cartridge.txt"`
version=`cat "$data_path/version.txt"`
export_folder="$carts_dirpath/${cartridge_stem}/v${version}_release"
cartridge_basename="${cartridge_stem}_v${version}_release"
rel_bin_folder="${cartridge_basename}.bin"

# Configuration: itch.io
author_itch=`cat "$data_path/author_itch.txt"`
title_itch=`cat "$data_path/title_itch.txt"`

help() {
  echo "Push build with specific version for all platforms to itch.io with butler."
  usage
}

usage() {
  echo "Usage: upload_cartridge_release.sh
"
}

if [[ $# -ne 0 ]]; then
  echo "Wrong number of arguments: found $#, expected 0."
  echo "Passed arguments: $@"
  usage
  exit 1
fi

# Arg $1: platform/format ('linux', 'osx', 'windows', 'web', 'png', 'p8')
# Arg $2: path to archive corresponding to platform/format
function butler_push_game_for_platform {
  platform="$1"
  filepath="$2"

  butler push --fix-permissions --userversion="$version" \
    "$filepath" "${author_itch}/${title_itch}:$platform"
}

pushd "${export_folder}"

  # Travis builds and releases .p8 cartridges packed in .zip, so focus on other platforms/formats
  # Upload web first, it matters for the initial upload as first one will be considered as web version
  # when using embedded web game on itch.io
  # itch.io's butler will be good enough to diff zips even if folder and file names slightly change with
  # release versions.
  butler_push_game_for_platform web "${cartridge_basename}_web.zip"
  butler_push_game_for_platform linux "${rel_bin_folder}/${cartridge_basename}_linux.zip"
  butler_push_game_for_platform osx "${rel_bin_folder}/${cartridge_basename}_osx.zip"
  butler_push_game_for_platform windows "${rel_bin_folder}/${cartridge_basename}_windows.zip"
  butler_push_game_for_platform png "${cartridge_basename}_png_cartridges.zip"
  butler_push_game_for_platform p8 "${cartridge_basename}_cartridges.zip"

popd
