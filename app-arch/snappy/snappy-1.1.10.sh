#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/google/snappy.git "${PV}"
acheck

cd "${T}"

docmake -G Ninja -DSNAPPY_BUILD_TESTS=OFF -DSNAPPY_BUILD_BENCHMARKS=OFF -DHAVE_LIBZ=NO -DHAVE_LIBLZO2=NO -DHAVE_LIBLZ4=NO

finalize
