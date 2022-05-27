#!/bin/sh
source "../../common/init.sh"

get https://dist.torproject.org/${P}.tar.gz
acheck

cd "${T}"

importpkg libevent openssl zlib

doconf

make
make install DESTDIR="${D}"

finalize
