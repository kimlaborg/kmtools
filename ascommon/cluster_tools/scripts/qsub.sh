#!/bin/bash

set -ex

function echo_err {
    echo "$@" 1>&2
}

function report_error {
    echo_err "ERROR!"
}
trap report_error ERR

exec 1> "$STDOUT_LOG"
exec 2> "$STDERR_LOG"

$SYSTEM_COMMAND

echo_err "DONE!"