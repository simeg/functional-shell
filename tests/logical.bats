#!/usr/bin/env bats

source "./map"
source "./ops/logical"

readonly res="tests/resources"
readonly empty_file="$res/empty_file"
readonly non_empty_file="$res/non_empty_file"

@test "logical: map non_empty" {
  actual="$(printf '%s\n' $non_empty_file $empty_file $non_empty_file | map non_empty)"
  expected="$(printf '%s\n' $non_empty_file $non_empty_file)"
  [ "$actual" == "$expected" ]
}
