#!/usr/bin/env bats

load "fixture"

readonly local res="tests/resources"
readonly local empty_file="$res/empty_file"
readonly local non_empty_file="$res/non_empty_file"
readonly local symlink="$res/symlink"
readonly local executable="$res/executable"
readonly local extension="$res/extension.md"

@test "file_and_dir: map abspath" {
  actual="$(printf '%s\n' $non_empty_file | _map abspath)"
  expected="$(printf '%s\n' tests/resources/non_empty_file)"
  [[ "$actual" == *"$expected" ]]
}

@test "file_and_dir: map dirname" {
  actual="$(printf '%s\n' $non_empty_file | _map dirname)"
  expected="$(printf '%s\n' resources)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map basename" {
  actual="$(printf '%s\n' $non_empty_file | _map basename)"
  expected="$(printf '%s\n' non_empty_file)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_dir [true]" {
  actual="$(printf '%s\n' $res | _map is_dir)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_dir [false]" {
  actual="$(printf '%s\n' $non_empty_file | _map is_dir)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_file [true]" {
  actual="$(printf '%s\n' $non_empty_file | _map is_file)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_file [false]" {
  actual="$(printf '%s\n' $res | _map is_file)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_link [true]" {
  actual="$(printf '%s\n' $symlink | _map is_link)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_link [false]" {
  actual="$(printf '%s\n' $non_empty_file | _map is_link)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_executable [true]" {
  actual="$(printf '%s\n' $executable | _map is_executable)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map is_executable [false]" {
  actual="$(printf '%s\n' $non_empty_file | _map is_executable)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map exists [true]" {
  actual="$(printf '%s\n' $non_empty_file | _map exists)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map exists [false]" {
  actual="$(printf '%s\n' some_non_existing_file | _map exists)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map has_ext [true]" {
  actual="$(printf '%s\n' $extension | _map has_ext md)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map has_ext [false]" {
  actual="$(printf '%s\n' $extension | _map has_ext not-md)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map strip_ext" {
  actual="$(printf '%s\n' $extension | _map strip_ext)"
  expected="$(printf '%s\n' tests/resources/extension)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map replace_ext" {
  actual="$(printf '%s\n' $extension | _map replace_ext other-ext)"
  expected="$(printf '%s\n' tests/resources/extension.other-ext)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map split_ext" {
  actual="$(printf '%s\n' $extension | _map split_ext)"
  expected="$(printf '%s\t%s\n' 'tests/resources/extension' 'md')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_dir [true]" {
  actual="$(printf '%s\n' $res | _filter is_dir)"
  expected="$(printf '%s\n' 'tests/resources')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_dir [false]" {
  actual="$(printf '%s\n' $non_empty_file | _filter is_dir)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_file [true]" {
  actual="$(printf '%s\n' $non_empty_file | _filter is_file)"
  expected="$(printf '%s\n' 'tests/resources/non_empty_file')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_file [false]" {
  actual="$(printf '%s\n' $res | _filter is_file)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_link [true]" {
  actual="$(printf '%s\n' $symlink | _filter is_link)"
  expected="$(printf '%s\n' 'tests/resources/symlink')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_link [false]" {
  actual="$(printf '%s\n' $non_empty_file | _filter is_link)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_executable [true]" {
  actual="$(printf '%s\n' $executable | _filter is_executable)"
  expected="$(printf '%s\n' 'tests/resources/executable')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter is_executable [false]" {
  actual="$(printf '%s\n' $non_empty_file | _filter is_executable)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter exists [true]" {
  actual="$(printf '%s\n' $non_empty_file | _filter exists)"
  expected="$(printf '%s\n' 'tests/resources/non_empty_file')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter exists [false]" {
  actual="$(printf '%s\n' some_non_existing_file | _filter exists)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter has_ext [true]" {
  actual="$(printf '%s\n' $extension | _filter has_ext md)"
  expected="$(printf '%s\n' 'tests/resources/extension.md')"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: filter has_ext [false]" {
  actual="$(printf '%s\n' $extension | _filter has_ext not-md)"
  expected="$(printf '%s\n' '')"
  [ "$actual" == "$expected" ]
}

