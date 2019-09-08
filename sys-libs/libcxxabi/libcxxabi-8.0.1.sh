#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz

cd "${T}"

# see http://llvm.org/docs/CMake.html

cmake ${CHPATH}/${P}.src -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.dev.${PVR} -DLIBCXXABI_LIBCXX_INCLUDES=`realpath /pkg/main/sys-libs.libcxx.dev/include/c++/v1`

cmake --build .

cmake -DCMAKE_INSTALL_PREFIX="${D}/pkg/main/${PKG}.dev.${PVR}" -P cmake_install.cmake

cd "${D}"

finalize