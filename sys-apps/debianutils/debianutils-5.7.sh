#!/bin/sh
source "../../common/init.sh"

get mirror://debian/pool/main/d/${PN}/${PN}_${PV}.orig.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
