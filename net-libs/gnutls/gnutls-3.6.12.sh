#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/gmp dev-libs/libunistring libunbound dev-libs/libtasn1

doconf

make
make install DESTDIR="${D}"

finalize
