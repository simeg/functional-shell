#!/usr/bin/env bats

load "fixture"

@test "other: map id" {
  actual="$(printf '%s\n' 1 2 | _map id)"
  result="$(printf '%s\n' 1 2)"
  [ "$actual" == "$result" ]
}

