#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/brotli/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/1.0.9-linker.patch"

cd "${T}" || exit

docmake

finalize
