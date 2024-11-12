#!/bin/sh
source "../../common/init.sh"

get https://github.com/llvm/llvm-project/releases/download/llvmorg-"${PV}"/cmake-"${PV}".src.tar.xz
acheck

mkdir -pv "${D}/pkg/main/${PKG}.src.${PVR}.any.any"
mv -v "$S" "${D}/pkg/main/${PKG}.src.${PVR}.any.any/cmake"

archive
