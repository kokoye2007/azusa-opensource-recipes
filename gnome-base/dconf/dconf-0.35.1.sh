#!/bin/sh
source "../../common/init.sh"

get https://download.gnome.org/sources/dconf/0.35/"${P}".tar.xz
acheck

cd "${T}" || exit

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
