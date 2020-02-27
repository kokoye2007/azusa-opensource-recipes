#!/bin/sh
source "../../common/init.sh"

get https://xorg.freedesktop.org/archive/individual/lib/${P}.tar.bz2
acheck

cd "${T}"

importpkg dev-libs/libbsd

doconf --enable-ipv6 --without-fop --localstatedir=/var --disable-static

make
make install DESTDIR="${D}"

finalize
