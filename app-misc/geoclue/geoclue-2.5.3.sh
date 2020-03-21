#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/${PV}/${P}.tar.bz2
acheck

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
