#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PVF}/lib64/cmake/llvm

cmake ${CHPATH}/${P}.src -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVRF} -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON \
	-DBUILD_SHARED_LIBS=ON

make
make install DESTDIR="${D}"

cd "${D}"

finalize
