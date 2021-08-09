#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz
acheck

cd "icu/source"

CC=gcc CXX=g++ doconf

make
make install DESTDIR="${D}"

# some pkgs (boost) require icu to have lib & include dirs in core, make symlinks
ln -snfT "/pkg/main/${PKG}.libs.${PVRF}/lib" "${D}/pkg/main/${PKG}.core.${PVRF}/lib"
ln -snfT "/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"
ln -snfT "/pkg/main/${PKG}.dev.${PVRF}/include" "${D}/pkg/main/${PKG}.core.${PVRF}/include"

finalize
