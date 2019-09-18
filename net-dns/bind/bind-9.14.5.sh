#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.isc.org/isc/bind9/${PV}/${P}.tar.gz

cd "${T}"

# pip3 install ply ?

doconf --sysconfdir=/etc --localstatedir=/var --with-libtool --disable-static

make
make install DESTDIR="${D}"

finalize
