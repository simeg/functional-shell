#!/usr/bin/env bash

#
# This script installs map and filter so that they are available on your $PATH
#
# It clones the repo, moves the files to /usr/local/bin and /usr/local/lib and
# finally removes the cloned repo
#

set -e

readonly tmp_dir="/tmp/functional-shell"


echo "-- Cloning repo..."

git clone https://github.com/simeg/functional-shell ${tmp_dir}

echo "-- Repo cloned!"

echo "-- Installing..."

# Install map and filter
cp -f ${tmp_dir}/map /usr/local/bin
cp -f ${tmp_dir}/filter /usr/local/bin

# Install operations
cp -rf ${tmp_dir}/fs /usr/local/lib

echo "-- Cleaning up temp files..."

rm -rf ${tmp_dir}

echo "-- All done!"

