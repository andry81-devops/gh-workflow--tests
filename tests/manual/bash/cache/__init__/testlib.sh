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

function testlib_init_accum_content()
{
  . $GH_WORKFLOW_ROOT/bash/cache/accum-content.sh

  echo

  testlib_fix_backend_paths
}
