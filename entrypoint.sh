#!/usr/bin/env bash
set -eux

PROJECT_SOURCE=${SRC_DIR:-/src}

test -d "$PROJECT_SOURCE"
cp -a "$PROJECT_SOURCE" ~/src
cd ~/src
if test -d ".git" -a -n "${GIT_CLEAN:-}"; then
    git clean -fdX
fi
tox "$@"