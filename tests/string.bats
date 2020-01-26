#!/usr/bin/env bats

source "fs/functions/_map"

@test "string: map reverse" {
  actual="$(printf '%s\n' hello_world | _map reverse)"
  expected="$(printf '%s\n' dlrow_olleh)"
  [ "$actual" == "$expected" ]
}

@test "string: map append" {
  actual="$(printf '%s\n' hello_world | _map append -yo)"
  expected="$(printf '%s\n' hello_world-yo)"
  [ "$actual" == "$expected" ]
}

@test "string: map strip" {
  actual="$(printf '%s\n' hello_world | _map strip)"
  expected="$(printf '%s\n' 'hello_world')"
  [ "$actual" == "$expected" ]
}

# TODO: Starting from here to bottom
@test "string: map substr" {
  actual="$(printf '%s\n' hello_world | _map substr 0 5)"
  expected="$(printf '%s\n' hello_)"
  [ "$actual" == "$expected" ]
}

@test "string: map take" {
  actual="$(printf '%s\n' hello_world | _map take 2)"
  expected="$(printf '%s\n' he)"
  [ "$actual" == "$expected" ]
}

@test "string: map to_lower" {
  actual="$(printf '%s\n' HELLO_WORLD | _map to_lower)"
  expected="$(printf '%s\n' hello_world)"
  [ "$actual" == "$expected" ]
}

@test "string: map to_upper" {
  actual="$(printf '%s\n' hello_world | _map to_upper)"
  expected="$(printf '%s\n' HELLO_WORLD)"
  [ "$actual" == "$expected" ]
}

@test "string: map replace" {
  actual="$(printf '%s\n' hello_world | _map replace hello bye_cruel)"
  expected="$(printf '%s\n' bye_cruel_world)"
  [ "$actual" == "$expected" ]
}

@test "string: map prepend" {
  actual="$(printf '%s\n' hello_world | _map prepend pre_)"
  expected="$(printf '%s\n' pre_hello_world)"
  [ "$actual" == "$expected" ]
}

@test "string: map capitalize" {
  actual="$(printf '%s\n' hello_world | _map capitalize)"
  expected="$(printf '%s\n' Hello_world)"
  [ "$actual" == "$expected" ]
}

@test "string: map drop" {
  actual="$(printf '%s\n' hello_world | _map drop 2)"
  expected="$(printf '%s\n' llo_world)"
  [ "$actual" == "$expected" ]
}

@test "string: map duplicate" {
  actual="$(printf '%s\n' hello_world | _map duplicate)"
  expected="$(printf '%s\n' 'hello_world hello_world')"
  [ "$actual" == "$expected" ]
}

@test "string: map contains [true]" {
  actual="$(printf '%s\n' hello_world | _map contains hell)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "string: map contains [false]" {
  actual="$(printf '%s\n' hello_world | _map contains nope)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "string: map starts_with [true]" {
  actual="$(printf '%s\n' hello_world | _map starts_with hell)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "string: map starts_with [false]" {
  actual="$(printf '%s\n' hello_world | _map starts_with nope)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "string: map ends_with [true]" {
  actual="$(printf '%s\n' hello_world | _map ends_with world)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "string: map ends_with [false]" {
  actual="$(printf '%s\n' hello_world | _map ends_with nope)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "string: map len" {
  actual="$(printf '%s\n' hello_world | _map len)"
  expected="$(printf '%s\n' 11)"
  [ "$actual" == "$expected" ]
}
