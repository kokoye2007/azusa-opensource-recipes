#!/bin/sh
source "../../common/init.sh"

get https://github.com/"${PN}"/"${PN}"/archive/v"${PV}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-devel/llvm

## XXX enable ARM on arm ?
docmake -DARM_ENABLED=OFF -DCMAKE_SKIP_RPATH=ON -DISPC_NO_DUMPS=ON

finalize
