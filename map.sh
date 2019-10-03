#!/usr/bin/env bash

set -e

# Load functions
source "./ops/arithmetic"
source "./ops/file_and_dir"
source "./ops/comparison"
source "./ops/string"
source "./ops/other"

function map {
  local fn_arg="$1"
  shift
  local args="$@"

  if [ "$(declare -f "$fn_arg" > /dev/null; echo $?)" -gt 0 ]; then
    echo "$fn_arg" is not a valid function
    exit 1
  fi

  # Change IFS to preserve whitespace in filenames
  localoldIfs=$IFS
  IFS=''

  while read -r LINE; do
    eval "$fn_arg" "'$LINE'" "'$args'"
  done < /dev/stdin

  IFS=$oldIfs
}

export -f map
