#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz
#acheck

cd "icu/source"

doconf

make
make install DESTDIR="${D}"

# some pkgs (boost) require icu to have lib & include dirs in core, make symlinks
ln -snfT "/pkg/main/${PKG}.libs.${PVR}/lib" "${D}/pkg/main/${PKG}.core.${PVR}/lib"
ln -snfT "/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX"
ln -snfT "/pkg/main/${PKG}.dev.${PVR}/include" "${D}/pkg/main/${PKG}.core.${PVR}/include"

finalize
