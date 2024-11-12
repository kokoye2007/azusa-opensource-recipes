#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/"${P}".tgz
acheck

cd "${T}" || exit

importpkg sys-libs/db:5.3 openssl dev-libs/cyrus-sasl

doconf

make
make install DESTDIR="${D}"

finalize
