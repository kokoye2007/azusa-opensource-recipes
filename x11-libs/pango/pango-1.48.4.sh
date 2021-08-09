#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/pango/1.42/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
