#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" && "${SOURCE_FILE%/*}" != '.' ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

TEST_DIR=$SOURCE_DIR

. $TEST_DIR/../__init__/__init__.sh || return || exit

. $TEST_DIR/../__init__/testlib.sh || return || exit

function test()
{
  testlib_init_yq_workflow || return
  testlib_yq_edit ".\"content-index\".timestamp=\"123\"" || return
  testlib_test_file_eq "$TEST_DIR/test.yml.ref" "$TEMP_DIR/test-edited-restored.yml"
}

if [[ -z "$BASH_LINENO" || BASH_LINENO[0] -eq 0 ]]; then
  # Script was not included, then execute it.
  test "$@"
fi
