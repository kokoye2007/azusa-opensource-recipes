#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/google/snappy.git "${PV}"
acheck

cd "${S}"

apatch "$FILESDIR/snappy-1.1.9_gcc_inline.patch"

cd "${T}"

docmake -G Ninja -DSNAPPY_BUILD_TESTS=OFF -DSNAPPY_BUILD_BENCHMARKS=OFF -DHAVE_LIBZ=NO -DHAVE_LIBLZO2=NO -DHAVE_LIBLZ4=NO

ninja
DESTDIR="${D}" ninja install

finalize
