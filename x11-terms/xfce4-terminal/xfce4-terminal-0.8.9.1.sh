#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/apps/${PN}/${PV%.*.*}/${P}.tar.bz2
acheck

importpkg dev-libs/libpcre2 zlib x11-base/xorg-proto x11-libs/libX11

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
