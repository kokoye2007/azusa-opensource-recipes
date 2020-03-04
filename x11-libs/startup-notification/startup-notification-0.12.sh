#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz
acheck

cd "${T}"

importpkg x11

doconf

make
make install DESTDIR="${D}"

finalize
