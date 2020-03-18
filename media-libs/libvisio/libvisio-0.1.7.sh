#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libvisio/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --with-docs --disable-static --enable-tools

make
make install DESTDIR="${D}"

finalize
