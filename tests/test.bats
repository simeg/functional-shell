#!/usr/bin/env bats

source "./functions/map"
source "./operations/arithmetic"

@test "map add" {
  actual="$(printf '%s\n' 1 2 | map add 1)"
  result="$(printf '%s\n' 2 3)"
  [ "$actual" == "$result" ]
}

@test "map sub" {
  actual="$(printf '%s\n' 2 3 | map sub 1)"
  result="$(printf '%s\n' 1 2)"
  [ "$actual" == "$result" ]
}

