#!/usr/bin/env bats

source "./map"
source "./operations/file_and_dir"

readonly res="tests/resources"
readonly empty_file="$res/empty_file"
readonly non_empty_file="$res/non_empty_file"
readonly symlink="$res/symlink"
readonly executable="$res/executable"
readonly extension="$res/extension.md"

# @test "file_and_dir: map abspath" {
#   actual="$(printf '%s\n' $non_empty_file | map abspath)"
#   expected="$(printf '%s\n' tests/resources/non_empty_file)"
#   [[ "$actual" == *"$expected" ]]
# }

# @test "file_and_dir: map dirname" {
#   actual="$(printf '%s\n' $non_empty_file | map dirname)"
#   expected="$(printf '%s\n' resources)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map basename" {
#   actual="$(printf '%s\n' $non_empty_file | map basename)"
#   expected="$(printf '%s\n' non_empty_file)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_dir [true]" {
#   actual="$(printf '%s\n' $res | map is_dir)"
#   expected="$(printf '%s\n' true)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_dir [false]" {
#   actual="$(printf '%s\n' $non_empty_file | map is_dir)"
#   expected="$(printf '%s\n' false)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_file [true]" {
#   actual="$(printf '%s\n' $non_empty_file | map is_file)"
#   expected="$(printf '%s\n' true)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_file [false]" {
#   actual="$(printf '%s\n' $res | map is_file)"
#   expected="$(printf '%s\n' false)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_link [true]" {
#   actual="$(printf '%s\n' $symlink | map is_link)"
#   expected="$(printf '%s\n' true)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_link [false]" {
#   actual="$(printf '%s\n' $non_empty_file | map is_link)"
#   expected="$(printf '%s\n' false)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_executable [true]" {
#   actual="$(printf '%s\n' $executable | map is_executable)"
#   expected="$(printf '%s\n' true)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map is_executable [false]" {
#   actual="$(printf '%s\n' $non_empty_file | map is_executable)"
#   expected="$(printf '%s\n' false)"
#   [ "$actual" == "$expected" ]
# }

# @test "file_and_dir: map exists [true]" {
#   actual="$(printf '%s\n' $non_empty_file | map exists)"
#   expected="$(printf '%s\n' true)"
#   [ "$actual" == "$expected" ]
# }

@test "file_and_dir: map exists [false]" {
  actual="$(printf '%s\n' some_non_existing_file | map exists)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map has_ext [true]" {
  actual="$(printf '%s\n' $extension | map has_ext md)"
  expected="$(printf '%s\n' true)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map has_ext [false]" {
  actual="$(printf '%s\n' $extension | map has_ext not-md)"
  expected="$(printf '%s\n' false)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map strip_ext" {
  actual="$(printf '%s\n' $extension | map strip_ext)"
  expected="$(printf '%s\n' tests/resources/extension)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map replace_ext" {
  actual="$(printf '%s\n' $extension | map replace_ext other-ext)"
  expected="$(printf '%s\n' tests/resources/extension.other-ext)"
  [ "$actual" == "$expected" ]
}

@test "file_and_dir: map split_ext" {
  actual="$(printf '%s\n' $extension | map split_ext)"
  expected="$(printf '%s\n' 'tests/resources/extension md')"
  [ "$actual" == "$expected" ]
}
