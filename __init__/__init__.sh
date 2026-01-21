#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

# Script can be ONLY included by "source" command.
[[ -n "$BASH" && (-z "$BASH_LINENO" || BASH_LINENO[0] -gt 0) && (-z "$GH_WORKFLOW_TESTS_PROJECT_ROOT_INIT0_DIR" || "$GH_WORKFLOW_TESTS_PROJECT_ROOT_INIT0_DIR" != "$SOURCE_DIR") ]] || return 0 || exit 0 # exit to avoid continue if the return can not be called

if [[ -z "$GH_WORKFLOW_ROOT" ]]; then
  echo "$0: error: \`GH_WORKFLOW_ROOT\` variable must be defined." >&2
  exit 255
fi

function __init__()
{
  GH_WORKFLOW_TESTS_PROJECT_ROOT=$(realpath $SOURCE_DIR/..)

  export TEMP_DIR=$GH_WORKFLOW_TESTS_PROJECT_ROOT/tmp

  [[ -d $TEMP_DIR ]] || mkdir $TEMP_DIR

  case "$OSTYPE" in
    msys* | mingw* | cygwin*)
      if [[ -z "$YQ_EXEC" && -f "$GH_WORKFLOW_TESTS_PROJECT_ROOT/tools/yq.exe" ]]; then
        YQ_EXEC=$GH_WORKFLOW_TESTS_PROJECT_ROOT/tools/yq.exe
        if [[ -f "$YQ_EXEC" ]]; then
          PATH=${YQ_EXEC%/*}:$PATH
          export YQ_EXEC
        fi
      fi
      ;;
  esac

  echo 'PATH:'
  local arg
  local IFS=':'
  for arg in $PATH; do
    echo "  * $arg"
  done
  echo

  GH_WORKFLOW_TESTS_PROJECT_ROOT_INIT0_DIR=$SOURCE_DIR
}

__init__
