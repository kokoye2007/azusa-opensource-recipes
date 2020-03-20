#!/bin/sh
source "../../common/init.sh"

get https://github.com/stefanberger/libtpms/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

importpkg openssl

doconf --with-openssl --with-tpm2

make
make install DESTDIR="${D}"

finalize
