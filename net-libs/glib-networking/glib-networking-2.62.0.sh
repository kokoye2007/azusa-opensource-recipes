#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.62/${P}.tar.xz
acheck

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" -Dlibproxy=disabled "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
