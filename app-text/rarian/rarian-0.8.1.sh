#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --disable-static --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
