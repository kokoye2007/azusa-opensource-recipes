#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libsigc++/3.0/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
