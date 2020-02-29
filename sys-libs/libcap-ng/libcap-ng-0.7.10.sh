#!/bin/sh
source "../../common/init.sh"

get https://people.redhat.com/sgrubb/libcap-ng/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
