#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/gnupg/${P}.tar.bz2
acheck

cd "${T}"

importpkg dev-libs/libgcrypt

doconf

make
make install DESTDIR="${D}"

finalize
