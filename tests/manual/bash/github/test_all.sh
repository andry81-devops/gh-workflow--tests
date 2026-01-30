#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" && "${SOURCE_FILE%/*}" != '.' ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

TEST_ALL_DIR=$SOURCE_DIR

. $TEST_ALL_DIR/__init__/__init__.sh || return || exit

. $TEST_ALL_DIR/__init__/testlib.sh || return || exit

function test_all()
{
  local file
  local fname

  for file in $TEST_ALL_DIR/*; do
    if [[ ! -d "$file" ]]; then continue; fi

    fname="${file##*/}"

    if [[ ! "$fname" =~ ^[0-9]+- ]]; then continue; fi

    . $file/test.sh && test
  done
}

if [[ -z "$BASH_LINENO" || BASH_LINENO[0] -eq 0 ]]; then
  # Script was not included, then execute it.
  test_all "$@"
fi
