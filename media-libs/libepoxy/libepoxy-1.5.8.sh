#!/bin/sh
source "../../common/init.sh"

get https://github.com/anholt/libepoxy/releases/download/${PV}/${P}.tar.xz
acheck

importpkg x11 egl

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
