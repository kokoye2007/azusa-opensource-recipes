#!/bin/sh
source "../../common/init.sh"

get https://github.com/facebook/rocksdb/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg dev-libs/jemalloc

cd "${S}" || exit

docmake -DFAIL_ON_WARNINGS=OFF -DPORTABLE=ON -DWITH_JEMALLOC=ON -DWITH_TESTS=OFF

finalize
