#!/bin/sh
source "../../common/init.sh"

inherit llvm
get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz

acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

docmake -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_LIBXML2=ON -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_APPEND_VC_REV=OFF -DWITH_POLLY=OFF -DLLVM_INSTALL_UTILS=ON \
	-DBUILD_SHARED_LIBS=ON -DCLANG_DEFAULT_CXX_STDLIB="libstdc++" -DCMAKE_CXX_STANDARD_LIBRARIES="-ldl" -DDEFAULT_SYSROOT="/pkg/main/sys-libs.glibc.dev" \
	-DLLVM_ENABLE_FFI=ON -DFFI_INCLUDE_DIR=/pkg/main/dev-libs.libffi.dev/include -DFFI_LIBRARY_DIR=/pkg/main/dev-libs.libffi.libs/lib$LIB_SUFFIX

finalize
