#!/bin/sh
source "../../common/init.sh"

get http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
