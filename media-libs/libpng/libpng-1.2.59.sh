#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/libpng/${P}.tar.xz

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
