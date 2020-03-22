#!/bin/sh
source "../../common/init.sh"

#get http://rpm5.org/files/popt/${P}.tar.gz
get ftp://anduin.linuxfromscratch.org/BLFS/popt/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
