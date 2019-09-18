#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/${P}.tar.xz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
