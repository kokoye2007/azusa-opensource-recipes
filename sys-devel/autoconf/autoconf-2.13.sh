#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconflight

make

# make install won't handle DESTDIR
make install # DESTDIR="${D}"

mkdir -pv "${D}/pkg/main"
mv -v /.pkg-main-rw/${PKG}.core.${PVR} "${D}/pkg/main"

finalize
