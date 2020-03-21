#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}/${P}.tar.gz
acheck

cd "${P}"

callconf --prefix=/pkg/main/${PKG}.fonts.${PVRF} --psfdir=/pkg/main/${PKG}.fonts.${PVRF}/consolefonts --x11dir=/pkg/main/${PKG}.fonts.${PVRF}/X11

make -j"$NPROC"
make install fontdir DESTDIR="${D}"

finalize
