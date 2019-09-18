#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/gspell/1.8/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
