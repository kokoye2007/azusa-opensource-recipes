#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/json-glib/1.4/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
