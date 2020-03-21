#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

importpkg zlib

cd "${T}"

# TODO fix docbook_docs building (xml-to)
meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
