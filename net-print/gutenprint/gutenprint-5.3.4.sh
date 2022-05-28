#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/gimp-print/${P}.tar.xz
acheck

cd "${T}"

importpkg app-arch/bzip2 dev-libs/libbsd sys-apps/util-linux sys-fs/udev

doconf

make
make install DESTDIR="${D}"

finalize
