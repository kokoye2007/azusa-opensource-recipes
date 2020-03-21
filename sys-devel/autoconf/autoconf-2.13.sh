#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconflight --program-suffix=-${PV}

# avoid install to fail
rm /pkg/main/${PKG}.core.${PVRF} || true

make
make install

# grab files from the installed path
mkdir -pv "${D}/pkg/main"
mv -v /.pkg-main-rw/${PKG}.core.${PVRF} "${D}/pkg/main"

finalize
