#!/bin/sh
source "../../common/init.sh"

LLVM_VERSION=16

get https://github.com/ziglang/zig/archive/refs/tags/${PV}.tar.gz ${P}.tar.gz
acheck

importpkg sys-devel/lld:$LLVM_VERSION sys-devel/clang:$LLVM_VERSION

cd "${T}"

# for some reason, zig is unable to find clang so we have to help it
docmake -DCLANG_LIBRARIES=/pkg/main/sys-devel.clang.libs.$LLVM_VERSION/lib/libclang-cpp.so.$LLVM_VERSION -DCLANG_INCLUDE_DIRS=/pkg/main/sys-devel.clang.dev.$LLVM_VERSION/include

finalize
