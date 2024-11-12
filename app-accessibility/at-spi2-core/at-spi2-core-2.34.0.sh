#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.34/"${P}".tar.xz

cd "${T}" || exit

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" --sysconfdir=/etc -Dsystemd_user_dir=no "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
