#!/usr/bin/env bats

source "./functions/map"
source "./operations/comparison"

@test "comparison: map eq [string]" {
  actual="$(printf '%s\n' file1 file2 | map eq file1)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map eq [int]" {
  actual="$(printf '%s\n' 1 2 | map eq 1)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}


@test "comparison: map ne [string]" {
  actual="$(printf '%s\n' file1 file2 | map ne file1)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map ne [int]" {
  actual="$(printf '%s\n' 1 2 | map ne 1)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map ge" {
  actual="$(printf '%s\n' 2 4 | map ge 4)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map gt" {
  actual="$(printf '%s\n' 2 4 | map gt 3)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map le" {
  actual="$(printf '%s\n' 2 4 | map le 2)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map lt" {
  actual="$(printf '%s\n' 2 4 | map lt 3)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}
