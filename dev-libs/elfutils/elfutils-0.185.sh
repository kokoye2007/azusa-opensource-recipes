#!/bin/sh
source "../../common/init.sh"

importpkg zlib

get ftp://sourceware.org/pub/elfutils/${PV}/${P}.tar.bz2
acheck

cd "${T}"

importpkg app-arch/bzip2 app-arch/xz app-arch/zstd

doconf

make
make install DESTDIR="${D}"

finalize
