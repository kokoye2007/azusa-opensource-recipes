#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
cd "$S"
apatch $FILESDIR/clang-9.0.1-libxml2-include-dirs.patch

acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib64/cmake/llvm

cmake ${CHPATH}/clang-${PV}.src -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVRF} -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_LIBXML2=ON -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_APPEND_VC_REV=OFF -DWITH_POLLY=OFF -DLLVM_INSTALL_UTILS=ON \
	-DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_STANDARD_LIBRARIES="-ldl" \
	-DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/pkg/main/dev-libs.libffi.dev/include -DFFI_LIBRARY_DIR=/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX

make -j"$NPROC" || /bin/bash -i
make install DESTDIR="${D}"

#cmake -DCMAKE_INSTALL_PREFIX="${D}/pkg/main/${PKG}.dev.${PVRF}" -P cmake_install.cmake

finalize
