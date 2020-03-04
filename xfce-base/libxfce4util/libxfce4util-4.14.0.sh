#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/libxfce4util/4.14/${P}.tar.bz2
acheck

cd "${T}"

doconf --with-vendor-info=AZUSA --enable-introspection --enable-startup-notification --enable-vala --enable-gladeui2

make
make install DESTDIR="${D}"

finalize
