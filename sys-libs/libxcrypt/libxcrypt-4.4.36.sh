#!/bin/sh
source "../../common/init.sh"

get https://github.com/besser82/"${PN}"/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
