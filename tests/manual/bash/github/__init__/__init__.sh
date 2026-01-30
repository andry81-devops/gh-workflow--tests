#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" && "${SOURCE_FILE%/*}" != '.' ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

# Script can be ONLY included by "source" command.
[[ -n "$BASH" && (-z "$BASH_LINENO" || BASH_LINENO[0] -gt 0) && (-z "$GH_WORKFLOW_TESTS_PROJECT_ROOT_INIT0_DIR" || "$GH_WORKFLOW_TESTS_PROJECT_ROOT_INIT0_DIR" != "$GH_WORKFLOW_TESTS_PROJECT_ROOT") ]] || return 0 || exit 0 # exit to avoid continue if the return can not be called

. $SOURCE_DIR/../../__init__/__init__.sh || return || exit
