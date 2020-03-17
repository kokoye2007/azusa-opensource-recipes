#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

docmake -DLIBCXXABI_LIBCXX_INCLUDES=/pkg/main/sys-libs.libcxx.dev.${PVR}/include/c++/v1

make
make install DESTDIR="${D}"

finalize
