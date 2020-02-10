#!/usr/bin/env bats

load "fixture"

@test "comparison: map eq [string]" {
  actual="$(printf '%s\n' file1 file2 | _map eq file1)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map eq [int]" {
  actual="$(printf '%s\n' 1 2 | _map eq 1)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map ne [string]" {
  actual="$(printf '%s\n' file1 file2 | _map ne file1)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map ne [int]" {
  actual="$(printf '%s\n' 1 2 | _map ne 1)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map ge" {
  actual="$(printf '%s\n' 2 4 | _map ge 4)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map gt" {
  actual="$(printf '%s\n' 2 4 | _map gt 3)"
  expected="$(printf '%s\n' false true)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map le" {
  actual="$(printf '%s\n' 2 4 | _map le 2)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: map lt" {
  actual="$(printf '%s\n' 2 4 | _map lt 3)"
  expected="$(printf '%s\n' true false)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter eq [string]" {
  actual="$(printf '%s\n' file1 file2 | _filter eq file1)"
  expected="$(printf '%s\n' file1)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter eq [int]" {
  actual="$(printf '%s\n' 1 2 | _filter eq 1)"
  expected="$(printf '%s\n' 1)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter ne [string]" {
  actual="$(printf '%s\n' file1 file2 | _filter ne file1)"
  expected="$(printf '%s\n' file2)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter ne [int]" {
  actual="$(printf '%s\n' 1 2 | _filter ne 1)"
  expected="$(printf '%s\n' 2)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter ge" {
  actual="$(printf '%s\n' 2 4 | _filter ge 4)"
  expected="$(printf '%s\n' 4)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter gt" {
  actual="$(printf '%s\n' 2 4 | _filter gt 3)"
  expected="$(printf '%s\n' 4)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter le" {
  actual="$(printf '%s\n' 2 4 | _filter le 2)"
  expected="$(printf '%s\n' 2)"
  [ "$actual" == "$expected" ]
}

@test "comparison: filter lt" {
  actual="$(printf '%s\n' 2 4 | _filter lt 3)"
  expected="$(printf '%s\n' 2)"
  [ "$actual" == "$expected" ]
}

