#!/bin/sh
source "../../common/init.sh"

get https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/${P}.tar.gz

cd "${T}"

export LD_LIBRARY_PATH=$(realpath /pkg/main/dev-libs.openssl.dev/lib)

# configure & build
doconf --with-zlib=`realpath /pkg/main/sys-libs.zlib.dev` --with-ssl-dir=`realpath /pkg/main/dev-libs.openssl.dev`

make
make install DESTDIR="${D}"

finalize
