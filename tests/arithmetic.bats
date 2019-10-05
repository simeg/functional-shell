#!/usr/bin/env bats

source "./functions/map"
source "./operations/arithmetic"

@test "arithmetic: map add" {
  actual="$(printf '%s\n' 1 2 | map add 1)"
  result="$(printf '%s\n' 2 3)"
  [ "$actual" == "$result" ]
}

@test "arithmetic: map sub" {
  actual="$(printf '%s\n' 2 3 | map sub 1)"
  result="$(printf '%s\n' 1 2)"
  [ "$actual" == "$result" ]
}

@test "arithmetic: map mul" {
  actual="$(printf '%s\n' 2 3 | map mul 2)"
  result="$(printf '%s\n' 4 6)"
  [ "$actual" == "$result" ]
}

@test "arithmetic: map pow" {
  actual="$(printf '%s\n' 2 3 | map pow 2)"
  result="$(printf '%s\n' 4 9)"
  [ "$actual" == "$result" ]
}

@test "arithmetic: map even" {
  actual="$(printf '%s\n' 1 2 | map even)"
  result="$(printf '%s\n' false true)"
  [ "$actual" == "$result" ]
}

@test "arithmetic: map odd" {
  actual="$(printf '%s\n' 1 2 | map odd)"
  result="$(printf '%s\n' true false)"
  [ "$actual" == "$result" ]
}

