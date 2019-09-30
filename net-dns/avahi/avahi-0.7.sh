#!/bin/sh
source "../../common/init.sh"

get http://avahi.org/download/${P}.tar.gz
acheck

cd "${T}"

doconf --sysconfdir=/etc --localstatedir=/var --disable-qt3 --disable-qt4 --disable-gtk --disable-gtk3 --disable-static --disable-mono --disable-monodoc --disable-python --with-distro=none --with-systemdsystemunitdir=no

make
make install DESTDIR="${D}"

finalize
