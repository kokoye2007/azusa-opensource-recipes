#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/rel${PV}/${P}.tar.xz
acheck

cd "${P}"
sed -i -e '/def_bf/s/MAXNAMELEN/MAXNAMELEN+4/' getdefs/getdefs.c

cd "${T}"

importpkg atomic_ops

doconf --disable-static --disable-dependency-tracking

make
make install DESTDIR="${D}"

finalize
