#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --enable-tools --with-docs --disable-static --program-suffix=-${PV%.*}

make
make install DESTDIR="${D}"

finalize
