#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg sys-libs/llvm-libunwind

cd "${T}" || exit

docmake -DBUILD_TESTING=OFF -DWITH_GFLAGS=ON -DWITH_GTEST=OFF -DWITH_UNWIND=ON

finalize
