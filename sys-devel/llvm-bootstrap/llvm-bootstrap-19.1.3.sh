#!/bin/sh
source "../../common/init.sh"
# this is only the base llvm

CATEGORY=sys-devel PN=llvm get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/llvm-project-${PV}.src.tar.xz
acheck

S="$S/llvm"

cd "${T}"

importpkg libxml-2.0 icu-uc sci-mathematics/z3 zlib

# importpkg will set CPPFLAGS but that's not read by llvm
export CFLAGS="${CPPFLAGS}"
export CXXFLAGS="${CPPFLAGS}"

# make sure previous config doesn't cause issues
rm -fr /pkg/main/${PKG}.data.${PVRF}/config

# https://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.data.${PVRF}" # use data to avoid addition to PATH

	-C "$S/../clang/cmake/caches/DistributionExample.cmake"

	-DCMAKE_C_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_CXX_FLAGS="${CPPFLAGS} -O2"
	-DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_SYSTEM_INCLUDE_PATH}"
	-DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_SYSTEM_LIBRARY_PATH}"

	-DLLVM_HOST_TRIPLE="${CHOST}"

	-DLLVM_LIBDIR_SUFFIX=$LIB_SUFFIX

	-DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}"
	#-DC_INCLUDE_DIRS="/pkg/main/sys-libs.glibc.dev.${OS}.${ARCH}/include"

	-DLIBCXXABI_USE_LLVM_UNWINDER=OFF

	-DPython3_EXECUTABLE=/bin/python3
)

# do not use llvmbuild since we are building llvm itself
# do not use docmake either since we want this to be contained in a data dir
cmake -S "${S}" -B "${T}" -G Ninja -Wno-dev "${CMAKE_OPTS[@]}"
ninja -j"$NPROC" -v stage2-distribution || /bin/bash -i
DESTDIR="${D}" ninja -j"$NPROC" -v stage2-install-distribution

fixelf
archive
