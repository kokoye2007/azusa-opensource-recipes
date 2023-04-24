#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost dev-libs/gmp dev-libs/isl

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
