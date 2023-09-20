#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN}-dev"
get ftp://ftp.freetds.org/pub/${PN}/current/${MY_PN}.${PV}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/libgcrypt dev-libs/libgpg-error dev-libs/gmp

doconf --enable-shared --disable-static --enable-libiconv --enable-krb5 --with-unixodbc --with-gnutls --with-openssl
#--enable-msdblib

make
make install DESTDIR="${D}"

finalize
