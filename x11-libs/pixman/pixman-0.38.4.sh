#!/bin/sh
source "../../common/init.sh"

get https://www.cairographics.org/releases/${P}.tar.gz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
