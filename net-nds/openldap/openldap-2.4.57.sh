#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${P}.tgz
acheck

cd "${T}"

importpkg sys-libs/db openssl dev-libs/cyrus-sasl

doconf

make
make install DESTDIR="${D}"

finalize
