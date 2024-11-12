#!/bin/sh
source "../../common/init.sh"

inherit llvm

# using full for lld to avoid the mach-o/compact_unwind_encoding.h bug
llvmget _lld libunwind

acheck

cd "${T}" || exit

#importpkg zlib libffi sys-devel/llvm
importpkg zlib

llvmbuild -DLLVM_ENABLE_TERMINFO=ON \
	-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON \
	-DBUILD_SHARED_LIBS=ON

finalize
