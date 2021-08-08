#!/bin/sh
source "../../common/init.sh"

get http://0pointer.de/lennart/projects/${PN}/${P}.tar.xz
acheck

importpkg sys-devel/libtool tdb zlib

cd "${T}"

doconf --disable-lynx --disable-gtk-doc --enable-alsa --disable-oss --enable-pulse --enable-gstreamer --enable-gtk --enable-gtk3 --enable-udev --enable-tdb

make
make install DESTDIR="${D}"

finalize
