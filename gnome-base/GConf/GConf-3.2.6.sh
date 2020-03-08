#!/bin/sh
source "../../common/init.sh"

get https://download.gnome.org/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

importpkg zlib

cd "${T}"

doconf --disable-orbit --disable-static

make
make install DESTDIR="${D}"

finalize
