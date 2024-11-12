#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libgudev/"${PV}"/"${P}".tar.xz

cd "${T}" || exit

doconf --disable-umockdev

make
make install DESTDIR="${D}"

finalize
