#!/bin/sh
source "../../common/init.sh"

get https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/${P}.tar.gz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
