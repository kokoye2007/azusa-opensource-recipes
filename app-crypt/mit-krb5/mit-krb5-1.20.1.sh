#!/bin/sh
source "../../common/init.sh"

get https://kerberos.org/dist/krb5/1.19/krb5-${PV}.tar.gz
acheck

cd "${T}"

CONFPATH="${S}/src/configure" doconf

make
make install DESTDIR="${D}"

finalize
