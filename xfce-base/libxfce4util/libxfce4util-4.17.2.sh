#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/libxfce4util/${PV%.*}/${P}.tar.bz2
acheck

cd "${T}"

doconf --with-vendor-info=AZUSA --enable-introspection --enable-vala

make
make install DESTDIR="${D}"

finalize
