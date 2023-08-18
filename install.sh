#!/bin/env bash

export SCRIPT_DIR="$( dirname -- "$( readlink -f -- "$0" )" )"

# Update Git submodules.
pushd "$SCRIPT_DIR" > /dev/null
git submodule update --init --recursive
popd > /dev/null

# Call each directory's install script.
for dir in */; do
    "$dir/install.sh"
done
