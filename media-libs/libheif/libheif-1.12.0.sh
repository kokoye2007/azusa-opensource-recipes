#!/bin/sh
source "../../common/init.sh"

get https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg libjpeg

doconf --disable-go --enable-aom --enable-libde265 --enable-multithreading --enable-x265 #--enable-rav1e

make
make install DESTDIR="${D}"

finalize
