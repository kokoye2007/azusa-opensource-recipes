#!/bin/sh
source "../../common/init.sh"

get https://www.openssl.org/source/${P}.tar.gz

cd "${P}"

./config --prefix=/pkg/main/${PKG}.core.${PVRF} --openssldir=/etc/ssl shared zlib-dynamic

make
make install MANSUFFIX=ssl INSTALL_PREFIX="${D}"

cd "${D}"
mv etc "pkg/main/${PKG}.core.${PVRF}"

finalize
