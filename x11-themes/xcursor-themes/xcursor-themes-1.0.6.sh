#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/data/${P}.tar.bz2
acheck

cd "${T}"

doconf

make install DESTDIR="${D}"

# will install in ${D}/pkg/main/x11-libs.libXcursor.core.*/share/
if [ -d "${D}/pkg/main/x11-libs.libXcursor.core".* ]; then
	mv -v "${D}/pkg/main/x11-libs.libXcursor.core".* "${D}/pkg/main/${PKG}.mod.${PVR}"
fi

finalize
