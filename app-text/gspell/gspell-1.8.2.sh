#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/gspell/1.8/${P}.tar.xz
acheck

cd "${T}"

importpkg uuid app-arch/bzip2 libbsd app-text/aspell

doconf

make
make install DESTDIR="${D}"

finalize
