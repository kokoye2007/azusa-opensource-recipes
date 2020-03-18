#!/bin/sh
source "../../common/init.sh"

get https://dev.gentoo.org/~blueness/eudev/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-apps/util-linux

doconf --enable-manpages --disable-static --config-cache --enable-hwdb --with-rootlibexecdir=/lib$LIB_SUFFIX/udev

make
make install DESTDIR="${D}"

finalize
