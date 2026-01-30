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

function testlib_yq_edit()
{
  cp -f $TEST_DIR/test.yml $TEMP_DIR

  yq_edit test edit $TEMP_DIR/test.yml $TEMP_DIR/test-[1]-edited.yml "$@" && \
    yq_diff $TEMP_DIR/test-[1]-edited.yml $TEMP_DIR/test.yml $TEMP_DIR/test-[2].diff && \
    yq_restore_edited_uniform_diff $TEMP_DIR/test-[2].diff $TEMP_DIR/test-[3]-edited-restored.diff && \
    yq_patch $TEMP_DIR/test-[1]-edited.yml $TEMP_DIR/test-[3]-edited-restored.diff $TEMP_DIR/temp.yml $TEMP_DIR/test-edited-restored.yml >/dev/null
  local last_error=$?

  return $last_error
}

function testlib_yq_restore_edited_uniform_diff()
{
  cp -f $TEST_DIR/test.diff $TEMP_DIR

  yq_restore_edited_uniform_diff $TEMP_DIR/test.diff $TEMP_DIR/test-restored.diff
}
