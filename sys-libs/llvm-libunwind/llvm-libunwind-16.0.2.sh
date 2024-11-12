#!/bin/sh
source "../../common/init.sh"

CATEGORY=sys-devel PN=llvm PKG="sys-devel.llvm" get https://github.com/llvm/llvm-project/releases/download/llvmorg-"${PV}"/llvm-project-"${PV}".src.tar.xz
S="$S/runtimes"

acheck

# see http://llvm.org/docs/CMake.html

CMAKE_OPTS=(
	-DLLVM_ENABLE_RUNTIMES="libunwind"
	-DPython3_EXECUTABLE="python3"
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_LIBDIR_SUFFIX=${LIB_SUFFIX}

	-DLLVM_INCLUDE_TESTS=OFF
	-DLIBUNWIND_ENABLE_ASSERTIONS=OFF
	-DLIBUNWIND_ENABLE_STATIC=ON
	-DLIBUNWIND_INCLUDE_TESTS=OFF
	-DLIBUNWIND_INSTALL_HEADERS=ON

	-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON
	-DLIBUNWIND_USE_COMPILER_RT=OFF # fails
)

cd "$T" || exit

# build libcxxabi
CMAKE_TARGET_INSTALL=install-unwind docmake "${CMAKE_OPTS[@]}"

finalize
