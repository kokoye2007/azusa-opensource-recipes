#!/bin/sh
source "../../common/init.sh"

get https://dev.gentoo.org/~flameeyes/dist/${P}.tar.bz2
acheck

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVR}/otf"
cp -v "${S}"/*.otf "${D}/pkg/main/${PKG}.fonts.${PVR}/otf"

finalize
