#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz
acheck

importpkg sys-libs/pam x11-libs/cairo sys-fs/udev

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}" -Dsystemd=false -Dlauncher-logind=false

ninja
DESTDIR="${D}" ninja install

finalize
