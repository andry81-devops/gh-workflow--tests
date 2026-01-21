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
