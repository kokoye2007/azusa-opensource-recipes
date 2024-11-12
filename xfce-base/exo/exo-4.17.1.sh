#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/"${PN}"/"${PV%.*}"/"${P}".tar.bz2
acheck

importpkg x11-libs/libX11 x11-base/xorg-proto zlib

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
