#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${P}.src.tar.xz
get https://github.com/llvm/llvm-project/releases/download/llvmorg-${PV}/${PN}abi-${PV}.src.tar.xz
mv ${PN}abi-${PV}.src ${PN}abi
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

docmake

make
make install DESTDIR="${D}"

finalize
