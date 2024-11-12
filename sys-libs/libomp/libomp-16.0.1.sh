#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-"${PV}"/openmp-"${PV}".src.tar.xz
CATEGORY=sys-devel PN=llvm get https://github.com/llvm/llvm-project/releases/download/llvmorg-"${PV}"/cmake-"${PV}".src.tar.xz
mv "cmake-${PV}.src" "cmake"
acheck

cd "${T}" || exit

# see http://llvm.org/docs/CMake.html

docmake -DCMAKE_MODULE_PATH=/pkg/main/sys-devel.llvm.dev."${PV}"/cmake/llvm -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_INCLUDE_TESTS=OFF

finalize
