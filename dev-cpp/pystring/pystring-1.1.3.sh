#!/bin/sh
source "../../common/init.sh"

get https://github.com/imageworks/pystring/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/cmake.patch"

cd "${T}" || exit

docmake

finalize
