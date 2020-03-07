#!/bin/sh
source "../../common/init.sh"

get http://anduin.linuxfromscratch.org/BLFS/bdb/${P}.tar.gz
acheck

prepare

cd "${P}"

sed -i 's/\(__atomic_compare_exchange\)/\1_db/' src/dbinc/atomic.h

cd "${T}"

CONFPATH="${CHPATH}/${P}/dist/configure" doconf --enable-compat185 --enable-dbm --disable-static --enable-cxx

make
make install DESTDIR="${D}"

finalize
