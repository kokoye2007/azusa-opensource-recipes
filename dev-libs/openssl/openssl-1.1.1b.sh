#!/bin/sh
source "../../common/init.sh"

get https://www.openssl.org/source/${P}.tar.gz

cd "${P}"

./config --prefix=/pkg/main/${PKG}.core.${PVR} --openssldir=/etc/ssl --libdir=/pkg/main/${PKG}.libs.${PVR}/lib shared zlib-dynamic

make
make install MANSUFFIX=ssl DESTDIR="${D}"

cd "${D}"
mv etc "pkg/main/${PKG}.core.${PVR}"

finalize
