#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-devel/libtool

doconf --sysconfdir=/etc --localstatedir=/var --disable-bluez4 --disable-bluez5 --disable-rpath --with-systemduserunitdir=no

make
make install DESTDIR="${D}"

finalize
