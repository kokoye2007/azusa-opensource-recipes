#!/bin/sh
source "../../common/init.sh"

get https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib sys-libs/pam sys-process/audit

# configure & build
doconf --sysconfdir=/etc/ssh --with-zlib=/pkg/main/sys-libs.zlib.dev --with-ssl-dir=/pkg/main/dev-libs.openssl.dev --with-audit=linux --with-pam
# --with-security-key-builtin

make
make install DESTDIR="${D}"

finalize
