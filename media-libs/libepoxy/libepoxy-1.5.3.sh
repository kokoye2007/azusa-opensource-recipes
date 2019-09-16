#!/bin/sh
source "../../common/init.sh"

get https://github.com/anholt/libepoxy/releases/download/${PV}/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
