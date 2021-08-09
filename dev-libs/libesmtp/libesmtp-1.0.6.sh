#!/bin/sh
source "../../common/init.sh"

get http://brianstafford.info/libesmtp/${P}.tar.bz2
acheck

importpkg openssl

cd "${S}"

# fix check for openssl
sed 's@SSL_library_init@SSL_new@g' -i configure.ac
aautoreconf

doconf --with-openssl

make
make install DESTDIR="${D}"

finalize
