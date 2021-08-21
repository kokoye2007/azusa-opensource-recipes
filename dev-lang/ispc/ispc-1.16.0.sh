#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

importpkg sys-devel/llvm

## XXX enable ARM on arm ?
docmake -G Ninja -DARM_ENABLED=OFF -DCMAKE_SKIP_RPATH=ON -DISPC_NO_DUMPS=ON

make
make install DESTDIR="${D}"

finalize
