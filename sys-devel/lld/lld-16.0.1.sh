#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz

CATEGORY=sys-devel PN=llvm get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/cmake-${PV}.src.tar.xz
mv "cmake-${PV}.src" "cmake"

acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

#importpkg zlib libffi sys-devel/llvm
importpkg zlib

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib$LIB_SUFFIX/cmake/llvm

docmake -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON \
	-DBUILD_SHARED_LIBS=ON

finalize
