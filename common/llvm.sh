#!/bin/sh

# enable llvm cmake
ln -snfv "/pkg/main/sys-devel.llvm-cmake.src.${PV}.any.any/cmake" "$WORKDIR/cmake"

# make it possible to run llvm tools within a non-azusa linux (TEMP)
export LLVM_DIR=/pkg/main/sys-devel.llvm.dev.${PV}/lib$LIB_SUFFIX/cmake/llvm

