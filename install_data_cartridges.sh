#!/bin/bash
# Install data cartridges to the default PICO-8 carts location,
#  merging data sections when needed to have 16 cartridges maximum.
# This should be done as part of install cartridge with data, or after editing data.

# Usage: install_data_cartridges.sh config
#   config            build config (e.g. 'debug' or 'release'. Default: 'debug')

# Currently only supported on Linux

# check that source and output paths have been provided
if ! [[ $# == 1 ]] ; then
    echo "install_single_cartridge_with_data.sh takes 1 param, provided $#:
    \$1: config ('debug', 'release', etc. Default: 'debug')"

    exit 1
fi

# Configuration: paths
data_path="$(dirname "$0")/data"

# Configuration: cartridge
cartridge_stem=`cat "$data_path/title_cartridge.txt"`
version=`cat "$data_path/version.txt"`
config="$1"; shift

# recompute same install dirpath as used in install_single_cartridge.sh
# (no need to mkdir -p "${install_dirpath}", it must have been created in said script)
carts_dirpath="$HOME/.lexaloffle/pico-8/carts"
install_dirpath="${carts_dirpath}/${cartridge_stem}/v${version}_${config}"

# Only try to copy data_*.p8 if any to avoid error if there are none
# https://unix.stackexchange.com/questions/79301/test-if-there-are-files-matching-a-pattern-in-order-to-execute-a-script
shopt -s nullglob
files=( data/data_*.p8 )

if [ ${#files[@]} -gt 0 ]; then
  # Copy data cartridges
  echo "Copying data cartridges data/data_*.p8 in ${install_dirpath} ..."
  # trailing slash just to make sure we copy to a directory
  cp ${files[@]} "${install_dirpath}/"
fi
