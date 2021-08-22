#!/bin/sh
source "../../common/init.sh"

get https://github.com/imageworks/pystring/archive/v${PV}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/cmake.patch"

cd "${T}"

docmake

finalize
