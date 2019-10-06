#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${P}"

sed '/valgrind/d' -i egg/egg-testing.c

cd "${T}"

importpkg dev-libs/libgcrypt

# TODO fix man
meson "${CHPATH}/${P}" --prefix=/pkg/main/${PKG}.core.${PVR} -Dgtk_doc=false -Dmanpage=false

ninja
DESTDIR="${D}" ninja install

finalize
