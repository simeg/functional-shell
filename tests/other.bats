#!/usr/bin/env bats

source "./map"
source "./ops/other"

@test "other: map id" {
  actual="$(printf '%s\n' 1 2 | map id)"
  result="$(printf '%s\n' 1 2)"
  [ "$actual" == "$result" ]
}


