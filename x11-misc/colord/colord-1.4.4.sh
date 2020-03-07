#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/${P}.tar.xz
acheck

cd "${T}"

echo meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}" -Dsystemd=false
/bin/bash -i
exit

ninja
DESTDIR="${D}" ninja install

finalize
