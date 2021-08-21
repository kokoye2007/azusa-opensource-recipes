#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/${P}.tar.xz
acheck

cd "${T}"

importpkg x11-libs/cairo

# TODO fix man (xslt)
meson --prefix="/pkg/main/${PKG}.core.${PVRF}" -Dcolord=yes -Dbroadway_backend=true "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
