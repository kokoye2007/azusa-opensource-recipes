#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${PV}/${P}.tar.bz2

cd "${T}"

importpkg X

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
