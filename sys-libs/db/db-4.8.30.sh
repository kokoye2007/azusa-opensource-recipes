#!/bin/sh
source "../../common/init.sh"

get http://download.oracle.com/berkeley-db/${P}.tar.gz
acheck

prepare

cd "${P}"

sed -i 's/\(__atomic_compare_exchange\)/\1_db/' dbinc/atomic.h

cd "${T}"

CONFPATH="${CHPATH}/${P}/dist/configure" doconf --enable-compat185 --enable-dbm --disable-static --enable-cxx

make
make install DESTDIR="${D}"

finalize
