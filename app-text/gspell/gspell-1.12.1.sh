#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/gspell/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg app-text/aspell zlib

doconf

make
make install DESTDIR="${D}"

finalize
