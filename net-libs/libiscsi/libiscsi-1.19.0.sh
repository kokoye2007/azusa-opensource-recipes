#!/bin/sh
source "../../common/init.sh"

get https://github.com/sahlberg/libiscsi/archive/refs/tags/"${PV}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
