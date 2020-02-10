#!/usr/bin/env bats

load "fixture"

readonly local res="tests/resources"
readonly local empty_file="$res/empty_file"
readonly local non_empty_file="$res/non_empty_file"

@test "logical: map non_empty [true]" {
  actual="$(printf '%s\n' $non_empty_file | _map non_empty)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "logical: map non_empty [false]" {
  actual="$(printf '%s\n' $empty_file | _map non_empty)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "logical: filter non_empty [true]" {
  actual="$(printf '%s\n' $non_empty_file | _filter non_empty)"
  expected="$(printf '%s\n' 'tests/resources/non_empty_file')"
  [ "$actual" == "$expected" ]
}

@test "logical: filter non_empty [false]" {
  actual="$(printf '%s\n' $empty_file | _filter non_empty)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}
