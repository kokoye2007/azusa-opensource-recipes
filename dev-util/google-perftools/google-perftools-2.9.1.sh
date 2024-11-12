#!/bin/sh
source "../../common/init.sh"

MY_P="gperftools-${PV}"
get https://github.com/gperftools/gperftools/archive/"${MY_P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
