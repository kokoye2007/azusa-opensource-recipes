#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/${P}.tgz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
