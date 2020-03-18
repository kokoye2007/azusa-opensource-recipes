#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libcdr/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
