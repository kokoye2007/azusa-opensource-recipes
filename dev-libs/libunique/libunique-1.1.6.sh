#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/${P}.tar.bz2

cd "${T}"

doconf --disable-dbus --disable-static

make
make install DESTDIR="${D}"

finalize
