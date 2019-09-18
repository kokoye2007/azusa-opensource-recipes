#!/bin/sh
source "../../common/init.sh"

get https://github.com/fribidi/fribidi/releases/download/v${PV}/${P}.tar.bz2

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
