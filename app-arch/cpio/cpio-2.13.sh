#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/${PN}/${P}.tar.bz2
acheck

cd "${S}"

apatch "${FILESDIR}/cpio-2.12-gcc-10.patch"

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
