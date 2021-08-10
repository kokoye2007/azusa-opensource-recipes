#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/google/snappy.git "${PV}"
acheck

importpkg dev-cpp/gtest

cd "${T}"

docmake -G Ninja -DSNAPPY_BUILD_TESTS:BOOL=OFF -DSNAPPY_BUILD_BENCHMARKS=OFF -DHAVE_LIBZ=NO -DHAVE_LIBLZO2=NO -DHAVE_LIBLZ4=NO

ninja
DESTDIR="${D}" ninja install

finalize
