#!/bin/sh
source "../../common/init.sh"

get http://ftp.nara.wide.ad.jp/pub/X11/GNOME/sources/vte/${PV:0:4}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib x11-libs/cairo

# TODO fix man building (xsltproc fails)
meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
