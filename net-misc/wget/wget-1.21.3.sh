#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg openssl

# configure & build
doconf --with-ssl=openssl --with-libssl-prefix=$(realpath /pkg/main/dev-libs.openssl.dev/)

make
make install DESTDIR="${D}"

finalize
