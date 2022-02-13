#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/openmp-${PV}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

docmake

finalize
