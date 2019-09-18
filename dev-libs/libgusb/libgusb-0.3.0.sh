#!/bin/sh
source "../../common/init.sh"

get https://people.freedesktop.org/~hughsient/releases/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" -Ddocs=false "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
