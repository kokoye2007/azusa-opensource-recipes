#!/bin/sh
source "../../common/init.sh"

get https://dist.torproject.org/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg libevent openssl zlib dev-libs/nss

doconf --enable-nss

make
make install DESTDIR="${D}"

finalize
