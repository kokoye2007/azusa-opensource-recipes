#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/${P}.tar.xz

cd "${T}"

importpkg dev-libs/gmp dev-libs/libunistring libunbound

doconf

make
make install DESTDIR="${D}"

finalize
