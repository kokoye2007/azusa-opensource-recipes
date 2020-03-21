#!/bin/sh
source "../../common/init.sh"

get https://download.gimp.org/pub/babl/0.1/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
