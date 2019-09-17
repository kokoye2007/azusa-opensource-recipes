#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/glibmm/2.60/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
