#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.63/${P}.tar.xz
acheck

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
