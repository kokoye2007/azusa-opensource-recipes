#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/libinput/${P}.tar.xz

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" "${CHPATH}/${P}" -Dudev-dir=/lib/udev -Ddebug-gui=false -Dtests=false -Ddocumentation=false -Dlibwacom=false

ninja
DESTDIR="${D}" ninja install

finalize
