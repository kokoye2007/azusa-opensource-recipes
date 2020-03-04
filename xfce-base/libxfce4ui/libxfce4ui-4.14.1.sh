#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/${PN}/${PV:0:4}/${P}.tar.bz2
acheck

cd "${T}"

importpkg x11 zlib

doconf

make
make install DESTDIR="${D}"

finalize
