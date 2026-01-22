#!/bin/bash

function testlib_fix_backend_paths()
{
  local var
  local IFS=$' \t'

  # convert backend system paths
  case "$OSTYPE" in
    msys* | mingw* | cygwin*)
      for var in TEST_DIR TEMP_DIR; do
        value="${!var}"
        value="$(/bin/cygpath.exe -w "$value")"
        value="${value//\\//}"
        # remove last slash
        declare -g $var="${value%[/\\]}"
      done
    ;;
  esac
}

function testlib_test_file_eq()
{
  local fn0=${1##*/}
  local fn1=${2##*/}

  if cmp -s "$@"; then
    echo "PASSED: ${TEST_DIR##*/}: \"$fn0\" \"$fn1\""
  else
    echo "FAILED: ${TEST_DIR##*/}: \"$fn0\" \"$fn1\""
    testlib_print_diff "$@"
  fi
}

function testlib_print_diff()
{
  diff -U0 -ad --horizon-lines=0 --suppress-common-lines "$@" | tail -n +3
}
