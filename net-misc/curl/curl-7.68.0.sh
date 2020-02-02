#!/bin/sh
source "../../common/init.sh"

get https://curl.haxx.se/download/${P}.tar.xz
acheck

cd "${T}"

importpkg libbrotlidec

doconf

make
make install DESTDIR="${D}"

finalize
