#!/bin/sh
source "../../common/init.sh"

MY_PV=$(echo "$PV" | sed -e 's/\./_/g')
get https://github.com/knik0/faad2/archive/"${MY_PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
