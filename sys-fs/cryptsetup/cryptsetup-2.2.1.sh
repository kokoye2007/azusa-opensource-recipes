#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/utils/cryptsetup/v2.2/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-apps/util-linux

doconf

make
make install DESTDIR="${D}"

finalize
