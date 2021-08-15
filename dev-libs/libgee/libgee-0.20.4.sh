#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

doconf --enable-introspection VALAC="$(type -P false)"

make
make install DESTDIR="${D}"

finalize
