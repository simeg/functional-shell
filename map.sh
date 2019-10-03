#!/usr/bin/env bash

set -e

# Load functions
source "./ops/arithmetic"
source "./ops/file_and_dir"
source "./ops/comparison"
source "./ops/string"

function map {
  local FN=$1

  if [ "$(declare -f "$FN" > /dev/null; echo $?)" -gt 0 ]; then
    echo "$FN" is not a valid function
    exit 1
  fi

  # Read piped input
  while read -r LINE; do
    if [ -n "$3" ]; then
      eval "$FN" "$LINE" "$2" "$3"
    elif [ -n "$2" ]; then
      eval "$FN" "$LINE" "$2"
    else
      eval "$FN" "$LINE"
    fi
  done < /dev/stdin
}

export -f map
