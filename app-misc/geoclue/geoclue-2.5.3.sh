#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/${PV}/${P}.tar.bz2
acheck

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" -Dgtk-doc=false "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
