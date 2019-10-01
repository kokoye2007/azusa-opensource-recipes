#!/bin/sh
source "../../common/init.sh"

get http://releases.llvm.org/${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib64/cmake/llvm

cmake ${CHPATH}/${P}.src -DLLVM_CONFIG=/pkg/main/sys-devel.llvm.core.${PV}/bin/llvm-config -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_LIBXML2=ON -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_APPEND_VC_REV=OFF -DWITH_POLLY=OFF -DLLVM_INSTALL_UTILS=ON \
	-DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON \
	-DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=`realpath /pkg/main/dev-libs.libffi.dev/include` -DFFI_LIBRARY_DIR=`realpath /pkg/main/dev-libs.libffi.libs/lib64`

make -j8
make install DESTDIR="${D}"

finalize
