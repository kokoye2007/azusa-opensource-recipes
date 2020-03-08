#!/bin/sh
source "../../common/init.sh"

get https://osdn.net/projects/lha/downloads/22231/lha-1.14i-ac20050924p1.tar.gz
acheck

prepare

cd "${T}"

callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
	--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man

make
make install DESTDIR="${D}"

finalize

