#!/bin/sh
source "../../common/init.sh"

get https://github.com/libarchive/libarchive/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg app-arch/bzip2 dev-libs/lzo

doconf --disable-static --with-lzo2

make
make install DESTDIR="${D}"

finalize
