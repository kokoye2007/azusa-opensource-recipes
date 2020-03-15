#!/bin/sh
source "../../common/init.sh"

get http://wgetpaste.zlin.dk/${P}.tar.bz2
acheck

cd "${S}"

PATCHES=( "${FILESDIR}/${P}-fix-bpaste.patch" )
apatch "${PATCHES[@]}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/bin"
mv "${PN}" "${D}/pkg/main/${PKG}.core.${PVR}/bin"

finalize
