#!/usr/bin/env bats

@test "addition" {
  result="$((2+2))"
  [ "$result" -eq 4 ]
}

@test "subtraction" {
  result="$((4-2))"
  [ "$result" -eq 2 ]
}
