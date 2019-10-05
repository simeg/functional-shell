#!/usr/bin/env bats

source "./map"
source "./operations/logical"

readonly res="tests/resources"
readonly empty_file="$res/empty_file"
readonly non_empty_file="$res/non_empty_file"

@test "logical: map non_empty [true]" {
  actual="$(printf '%s\n' $non_empty_file | map non_empty)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "logical: map non_empty [false]" {
  actual="$(printf '%s\n' $empty_file | map non_empty)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}
