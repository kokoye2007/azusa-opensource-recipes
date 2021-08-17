#!/bin/sh
source "../../common/init.sh"

get https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg libjpeg

doconf

make
make install DESTDIR="${D}"

finalize
