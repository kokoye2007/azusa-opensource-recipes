#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz
acheck

importpkg sys-libs/pam x11-libs/cairo sys-fs/eudev media-libs/libglvnd

cd "${T}"

domeson -Dsystemd=false -Dlauncher-logind=false

ninja
DESTDIR="${D}" ninja install

finalize
