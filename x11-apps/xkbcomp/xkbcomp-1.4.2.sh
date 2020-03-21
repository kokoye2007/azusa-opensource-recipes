#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/app/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

# create a symlink to /pkg/main/x11-misc.xkeyboard-config.core/share since somehow X11 will look for xkb rules here
ln -snfTv /pkg/main/x11-misc.xkeyboard-config.core/share "${D}/pkg/main/${PKG}.core.${PVRF}/share"

finalize
