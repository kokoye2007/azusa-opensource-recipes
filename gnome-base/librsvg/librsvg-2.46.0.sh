#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/librsvg/2.46/${P}.tar.xz
acheck

cd "${T}"

doconf --enable-vala --disable-static

make
make install DESTDIR="${D}"

finalize
