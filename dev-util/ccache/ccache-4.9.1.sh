#!/bin/sh
source "../../common/init.sh"

get https://github.com/ccache/ccache/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg app-arch/zstd

# Found hiredis, version 1.0.2
# but still fails, so disable for now
docmake -DREDIS_STORAGE_BACKEND=OFF

finalize
