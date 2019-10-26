#!/bin/sh
source "../../common/init.sh"

get https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/${P}.tar.gz
acheck

cd "${T}"

# configure & build
doconf --sysconfdir=/etc/ssh --with-zlib=`realpath /pkg/main/sys-libs.zlib.dev` --with-ssl-dir=`realpath /pkg/main/dev-libs.openssl.dev`

make
make install DESTDIR="${D}"

finalize
