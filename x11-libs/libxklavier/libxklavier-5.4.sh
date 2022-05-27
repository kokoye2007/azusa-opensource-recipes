#!/bin/sh
source "../../common/init.sh"

get https://people.freedesktop.org/~svu/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-gtk-doc --enable-introspection --enable-vala #--with-xkb-base=/usr/share/X11/xkb --with-xkb-bin-base=/usr/bin

make
make install DESTDIR="${D}"

finalize
