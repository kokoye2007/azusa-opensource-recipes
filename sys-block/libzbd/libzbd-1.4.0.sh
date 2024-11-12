#!/bin/sh
source "../../common/init.sh"

get https://github.com/westerndigitalcorporation/libzbd/archive/refs/tags/v"${PV}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

#cd "${T}"
importpkg zlib

doconf

make V=1
make install DESTDIR="${D}"

finalize
