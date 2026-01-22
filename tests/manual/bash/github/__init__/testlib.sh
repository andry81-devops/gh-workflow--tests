#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

. $SOURCE_DIR/../../__init__/testlib.sh || return || exit

function testlib_init_yq_workflow()
{
  . $GH_WORKFLOW_ROOT/bash/github/init-yq-workflow.sh

  tkl_execute_calls gh

  echo

  testlib_fix_backend_paths
}
