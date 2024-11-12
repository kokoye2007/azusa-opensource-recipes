#!/bin/sh
source "../../common/init.sh"

get https://www.openssl.org/source/"${P}".tar.gz
acheck

cd "${P}" || exit

importpkg zlib

./config --prefix=/pkg/main/"${PKG}".core."${PVRF}" --openssldir=/etc/ssl --libdir=/pkg/main/"${PKG}".libs."${PVRF}"/lib"$LIB_SUFFIX" shared zlib-dynamic

make
make install MANSUFFIX=ssl DESTDIR="${D}"

cd "${D}" || exit
mv etc "pkg/main/${PKG}.core.${PVRF}"

finalize
