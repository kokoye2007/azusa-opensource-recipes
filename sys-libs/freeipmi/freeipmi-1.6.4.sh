#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

importpkg libgcrypt

doconf

make
make install DESTDIR="${D}"

finalize
