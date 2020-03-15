#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
