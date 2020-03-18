#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libmspub/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --disable-werror --disable-static

make
make install DESTDIR="${D}"

finalize
