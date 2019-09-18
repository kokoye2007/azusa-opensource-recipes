#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/${P}.tar.xz

export LD_LIBRARY_PATH=/pkg/main/dev-libs.glib.core/lib$LIB_SUFFIX

cd "${T}"

doconf --sysconfdir=/etc --enable-egl-backend --enable-evdev-input --enable-wayland-backend --enable-wayland-compositor

make
make install DESTDIR="${D}"

finalize
