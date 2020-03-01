#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/${P}.tar.xz
acheck

cd "${T}"

# TODO fix man building (xsltproc fails)
meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}" -Dman=false -Dsystemd=false

ninja
DESTDIR="${D}" ninja install

finalize
