#!/bin/sh
source "../../common/init.sh"

get https://www.openssl.org/source/${P}.tar.gz
acheck

cd "${P}"

importpkg zlib

# libdir cannot be an absolute path anymore

./config --prefix=/pkg/main/${PKG}.core.${PVRF} --openssldir=/etc/ssl --libdir=lib$LIB_SUFFIX shared zlib-dynamic

make -j"$NPROC"
make install MANSUFFIX=ssl DESTDIR="${D}"

cd "${D}"
mv etc "pkg/main/${PKG}.core.${PVRF}"

finalize
