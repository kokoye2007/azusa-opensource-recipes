#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

FORCE_UNSAFE_CONFIGURE=1 doconf

make
make install DESTDIR="${D}"

finalize
