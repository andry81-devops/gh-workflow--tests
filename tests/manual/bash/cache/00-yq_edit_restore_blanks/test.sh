#!/bin/bash

SOURCE_FILE=${BASH_SOURCE[0]:-${0//\\//}}

if [[ "${SOURCE_FILE:0:1}" == '/' || "${SOURCE_FILE:1:1}" == ':' ]]; then
  SOURCE_DIR=${SOURCE_FILE%/*}
elif [[ "${SOURCE_FILE/\//}" != "$SOURCE_FILE" ]]; then
  SOURCE_DIR=$PWD/${SOURCE_FILE%/*}
else
  SOURCE_DIR=$PWD
fi

TEST_DIR=$SOURCE_DIR

. $SOURCE_DIR/../__init__/__init__.sh || return || exit

. $GH_WORKFLOW_ROOT/bash/cache/accum-content.sh

echo

IFS=$' \t'

# convert backend system paths
case "$OSTYPE" in
  msys* | mingw* | cygwin*)
    for var in TEST_DIR TEMP_DIR; do
      value="${!var}"
      value="$(/bin/cygpath.exe -w "$value")"
      value="${value//\\//}"
      # remove last slash
      declare $var="${value%[/\\]}"
    done
  ;;
esac

cp -f $TEST_DIR/test.yml $TEMP_DIR

yq_edit test edit $TEMP_DIR/test.yml $TEMP_DIR/test-[1]-edited.yml ".\"content-index\".timestamp=\"123\"" && \
  yq_diff $TEMP_DIR/test-[1]-edited.yml test.yml $TEMP_DIR/test-[2].diff && \
  yq_restore_edited_uniform_diff $TEMP_DIR/test-[2].diff $TEMP_DIR/test-[3]-edited-restored.diff && \
  yq_patch $TEMP_DIR/test-[1]-edited.yml $TEMP_DIR/test-[3]-edited-restored.diff $TEMP_DIR/temp.yml $TEMP_DIR/test-restored.yml
