#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

importpkg zlib libffi sys-devel/llvm

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}.${OS}.${ARCH}/lib$LIB_SUFFIX/cmake/llvm

# does not support parallel build, so force unix makefile with -j1

#NPROC=1 CMAKE_ROOT="${CHPATH}/${P}.src" CMAKE_BUILD_ENGINE="Unix Makefiles" docmake -DLLVM_ENABLE_TERMINFO=ON \
CMAKE_ROOT="${CHPATH}/${P}.src" docmake -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON \
	-DBUILD_SHARED_LIBS=ON
	#-DZLIB_LIBRARY=/pkg/main/sys-libs.zlib.libs.${OS}.${ARCH}/lib$LIB_SUFFIX/libz.so -DZLIB_INCLUDE_DIR=/pkg/main/sys-libs.zlib.dev.${OS}.${ARCH}/include \
	#-DFFI_LIBRARIES=/pkg/main/dev-libs.libffi.libs.${OS}.${ARCH}/lib64/libffi.so -DHAVE_FFI_CALL=ON

finalize
