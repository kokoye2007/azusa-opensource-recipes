#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libwnck/${PV%.*}/${P}.tar.xz
acheck

importpkg zlib

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
