#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/${P}.tar.xz

cd "${T}"

export LD_LIBRARY_PATH=/pkg/main/dev-libs.glib.core/lib$LIB_SUFFIX

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
