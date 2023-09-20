#!/bin/sh
source "../../common/init.sh"

get https://www.cabextract.org.uk/libmspack/libmspack-${PV}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
