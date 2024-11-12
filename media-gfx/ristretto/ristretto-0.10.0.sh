#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/apps/"${PN}"/"${PV%.*}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg zlib x11-libs/cairo x11-base/xorg-proto x11-libs/libX11

doconf

make
make install DESTDIR="${D}"

finalize
