#!/bin/sh
source "../../common/init.sh"

get https://github.com/facebook/rocksdb/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg dev-libs/jemalloc

cd "${S}" || exit

apatch "$FILESDIR"/rocksdb-6.14.6-gcc13.patch

# enable RTTI as it is needed for ceph and maybe others?
docmake -DFAIL_ON_WARNINGS=OFF -DPORTABLE=ON -DWITH_JEMALLOC=ON -DWITH_TESTS=OFF -DUSE_RTTI:BOOL=ON

finalize
