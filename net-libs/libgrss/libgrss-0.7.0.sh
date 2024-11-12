#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libgrss/0.7/"${P}".tar.xz
acheck

cd "${P}" || exit

patch -p1 <"$FILESDIR/libgrss-0.7.0-bugfixes-1.patch"
autoreconf -fiv

cd "${T}" || exit

importpkg dev-libs/icu
doconf --disable-static

make
make install DESTDIR="${D}"

finalize
