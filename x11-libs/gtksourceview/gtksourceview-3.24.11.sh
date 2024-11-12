#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/"${PN}"/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg zlib

doconf --enable-gtk-doc

make
make install DESTDIR="${D}"

finalize
