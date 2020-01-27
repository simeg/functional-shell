#!/usr/bin/env bash

set -e

echo "Cloning repo..."

git clone https://github.com/simeg/functional-shell /tmp/functional-shell

echo "Repo cloned!"

echo "Installing..."

cp -f /tmp/functional-shell/filter /usr/local/bin
cp -f /tmp/functional-shell/map /usr/local/bin

cp -rf /tmp/functional-shell/fs /usr/local/lib

echo "Done!"

