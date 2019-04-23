#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/m4/${P}.tar.xz

patch -p0 <"$FILESDIR/m4-1.4.18-glibc-change-work-around.patch"

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
