#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/${P}.tar.xz

cd "${T}"

doconf --sysconfdir=/etc --enable-egl-backend --enable-evdev-input --enable-wayland-backend --enable-wayland-compositor

make
make install DESTDIR="${D}"

finalize
