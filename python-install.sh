#!/bin/bash
# Usage:
#  $ ./python-install.sh install 3.7.3 ./python
#  $ ./python-install.sh altinstall 3.5.3 ./python
#  $ sudo ./python-install.sh altinstall 3.6.8

set -eux

INSTALL="$1"
VERSION="$2"
PREFIX=""
if test $# -ge 3; then
    PREFIX="$3"
fi

SRC_FOLDER=$(mktemp -d --suffix "_$VERSION")
cd "$SRC_FOLDER"
wget "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -O python.tar.xz
tar -xJv --strip-components=1 -f python.tar.xz
rm python.tar.xz

if test -n "$PREFIX"; then
    PREFIX=$(realpath "$PREFIX")
    mkdir -p "$PREFIX"
    ./configure --prefix "$PREFIX"
else
    ./configure
fi
make -j4
make $INSTALL
cd /tmp && rm -rf "$SRC_FOLDER"
