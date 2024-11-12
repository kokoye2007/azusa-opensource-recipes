#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libgsf/1.14/"${P}".tar.xz

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
