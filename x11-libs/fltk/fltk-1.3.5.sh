#!/bin/sh
source "../../common/init.sh"

get https://www.fltk.org/pub/fltk/${PV}/${P}-source.tar.bz2
acheck

cd "${P}"

importpkg X zlib libpng libjpeg fontconfig

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
