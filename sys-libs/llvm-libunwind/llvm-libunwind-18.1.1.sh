#!/bin/sh
source "../../common/init.sh"
inherit llvm

llvmget runtimes

acheck

# see http://llvm.org/docs/CMake.html

export CC=/pkg/main/sys-devel.clang.core/bin/clang
export CXX=/pkg/main/sys-devel.clang.core/bin/clang++

importpkg zlib

CMAKE_OPTS=(
	-DLLVM_ENABLE_RUNTIMES="libunwind"
	-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
	-DLIBUNWIND_ENABLE_STATIC=ON
	-DLIBUNWIND_INCLUDE_TESTS=OFF
	-DLIBUNWIND_INSTALL_HEADERS=ON

	-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON
	-DLIBUNWIND_USE_COMPILER_RT=ON
)

cd "$T" || exit

llvmbuild "${CMAKE_OPTS[@]}"

finalize
