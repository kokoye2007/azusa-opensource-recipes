#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/"${PN}"/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
