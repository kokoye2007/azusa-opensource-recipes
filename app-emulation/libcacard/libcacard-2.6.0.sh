#!/bin/sh
source "../../common/init.sh"

get https://www.spice-space.org/download/libcacard/${P}.tar.xz
acheck

importpkg sys-apps/pcsc-lite

cd "${T}"

doconf --enable-pcsc

make
make install DESTDIR="${D}"

finalize
