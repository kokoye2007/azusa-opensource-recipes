#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/xserver/${P}.tar.bz2

cd "${T}"

doconf --enable-glamor --enable-suid-wrapper --disable-systemd-logind --with-xkb-output=/var/lib/xkb --enable-dmx --enable-kdrive
# --enable-install-setuid

make
make install DESTDIR="${D}"

finalize
