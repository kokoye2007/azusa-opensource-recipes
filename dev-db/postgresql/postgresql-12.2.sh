#!/bin/sh
source "../../common/init.sh"

get http://ftp.postgresql.org/pub/source/v${PV}/${P}.tar.bz2
acheck

cd "${T}"

doconf --enable-thread-safety

make
make install DESTDIR="${D}"
make install-docs DESTDIR="${D}"

finalize
