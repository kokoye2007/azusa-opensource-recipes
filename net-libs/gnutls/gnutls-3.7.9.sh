#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/gnutls/v"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/gmp dev-libs/libunistring libunbound dev-libs/libtasn1 app-arch/brotli

doconf

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
