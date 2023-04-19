#!/bin/sh
source "../../common/init.sh"

get https://libbsd.freedesktop.org/releases/${P}.tar.xz
acheck

cd "${T}"

importpkg app-crypt/libmd

doconf

make
make install DESTDIR="${D}"

finalize
