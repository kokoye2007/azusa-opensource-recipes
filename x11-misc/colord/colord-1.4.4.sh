#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/${P}.tar.xz
acheck

importpkg media-libs/lcms

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}" -Dsystemd=false -Ddaemon_user=colord

ninja
DESTDIR="${D}" ninja install

finalize
