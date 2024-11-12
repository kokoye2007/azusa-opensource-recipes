#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/"${PN}"/"${PV%.*}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg x11-libs/libX11 x11-base/xorg-proto zlib x11-libs/cairo x11-libs/libXext

doconf --enable-gtk-doc --disable-vala

make
make install DESTDIR="${D}"

finalize
