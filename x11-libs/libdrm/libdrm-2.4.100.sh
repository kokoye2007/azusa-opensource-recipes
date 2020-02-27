#!/bin/sh
source "../../common/init.sh"

get https://dri.freedesktop.org/libdrm/${P}.tar.bz2
acheck

cd "${T}"

importpkg app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd

doconf

make
make install DESTDIR="${D}"

finalize
