#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.38/${P}.tar.xz

cd "${T}"

importpkg media-libs/libjpeg-turbo

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

"${D}/pkg/main/${PKG}.core.${PVR}/bin/gdk-pixbuf-query-loaders" > "${D}/pkg/main/${PKG}.core.${PVR}/lib64"/gdk-pixbuf-*/2.*/loaders.cache

finalize
