#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV}/${P}.tar.bz2
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVRF}" "${D}/pkg/main/${PKG}.doc.${PVRF}"
mv -v *.ttf "${D}/pkg/main/${PKG}.fonts.${PVRF}"
mv -v *.TXT *.conf "${D}/pkg/main/${PKG}.doc.${PVRF}"

finalize
