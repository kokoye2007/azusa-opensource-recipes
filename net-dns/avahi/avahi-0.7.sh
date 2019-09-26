#!/bin/sh
source "../../common/init.sh"

get http://avahi.org/download/${P}.tar.gz

cd "${T}"

doconf --disable-qt3 --disable-qt4 --disable-gtk --disable-gtk3 --disable-static 

make
make install DESTDIR="${D}"

finalize
