#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/brotli/archive/v${PV}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/1.0.9-linker.patch"

cd "${T}"

docmake

finalize
