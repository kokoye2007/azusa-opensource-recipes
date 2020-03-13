#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}/${P}.tar.gz
acheck

cd "${P}"

callconf --prefix=/pkg/main/${PKG}.fonts.${PVR} --psfdir=/pkg/main/${PKG}.fonts.${PVR}/consolefonts --x11dir=/pkg/main/${PKG}.fonts.${PVR}/X11

make -j"$NPROC"
make install fontdir DESTDIR="${D}"

finalize
