#!/bin/sh
source "../../common/init.sh"

get https://www.aleksey.com/xmlsec/download/"${PN}"1-"${PV}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-devel/libtool dev-libs/libgcrypt dev-libs/libgpg-error

doconf --enable-docs --disable-static --with-gcrypt --with-gnutls --with-nspr --with-nss --with-openssl --enable-mans --enable-pkgconfig

make
make install DESTDIR="${D}"

finalize
