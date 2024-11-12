#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/apps/"${PN}"/"${PV%.*}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg zlib gstreamer-tag-1.0 x11

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
