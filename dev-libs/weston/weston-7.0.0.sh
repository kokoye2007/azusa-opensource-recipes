#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz
acheck

importpkg sys-libs/pam

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}" -Dsystemd=false -Dlauncher-logind=false

ninja
DESTDIR="${D}" ninja install

finalize
