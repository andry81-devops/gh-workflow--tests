#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" && "${SOURCE_FILE%/*}" != '.' ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

. $SOURCE_DIR/../../__init__/testlib.sh || return || exit

function testlib_init_yq_workflow()
{
  (( ! SOURCE_GHWF_INIT_YQ_WORKFLOW_SH )) || return 0

  . $GH_WORKFLOW_ROOT/bash/github/init-yq-workflow.sh

  tkl_execute_calls gh

  echo

  testlib_fix_backend_paths
}

function testlib_test_yq_edit()
{
  testlib_init_yq_workflow || return
  testlib_yq_edit ".\"content-index\".timestamp=\"123\"" || > "$TEMP_DIR/test-edited-restored.yml"
  testlib_test_file_eq "$TEST_DIR/test.yml.ref" "$TEMP_DIR/test-edited-restored.yml"
}

function testlib_test_yq_restore_edited_uniform_diff()
{
  testlib_init_yq_workflow || return
  testlib_yq_restore_edited_uniform_diff || > "$TEMP_DIR/test-restored.diff"
  testlib_test_file_eq "$TEST_DIR/test.diff.ref" "$TEMP_DIR/test-restored.diff"
}
