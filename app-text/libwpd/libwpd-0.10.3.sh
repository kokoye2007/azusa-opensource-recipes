#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.xz
acheck

cd "${S}"

apatch "$FILESDIR/libwpd-0.10.3-gcc-4.8.patch"

cd "${T}"

importpkg dev-libs/boost

doconf --enable-tools --with-docs --disable-static --program-suffix=-${PV%.*}

make
make install DESTDIR="${D}"

finalize
