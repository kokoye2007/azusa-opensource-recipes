#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libunique/1.1/"${P}".tar.bz2
acheck

cd "${P}" || exit
patch -p1 -i "$FILESDIR/libunique-1.1.6-upstream_fixes-1.patch"
aautoreconf

#cd "${T}"

doconf --disable-dbus --disable-static

make
make install DESTDIR="${D}"

finalize
