#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/"${PN}"/"${PV%.*}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --disable-debug --enable-libgamin --enable-server --enable-inotify --without-python

make
make install DESTDIR="${D}"

finalize
