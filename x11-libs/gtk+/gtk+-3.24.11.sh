#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/${P}.tar.xz
acheck

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" -Dcolord=yes -Dgtk_doc=false -Dman=true -Dbroadway_backend=true "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
