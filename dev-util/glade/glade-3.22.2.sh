#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/GNOME/sources/"${PN}"/"${PV:0:4}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
