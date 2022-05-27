#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.gnu.org/gnu/gdbm/${P}.tar.gz
acheck

cd "${T}"

importpkg readline

# configure & build
doconf --enable-libgdbm-compat

make
make install DESTDIR="${D}"

finalize
