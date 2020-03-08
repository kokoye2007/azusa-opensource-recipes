#!/bin/sh
source "../../common/init.sh"

get https://people.redhat.com/sgrubb/audit/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-zos-remote --without-python --without-python3

make
make install DESTDIR="${D}"

finalize
