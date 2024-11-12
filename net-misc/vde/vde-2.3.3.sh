#!/bin/sh
source "../../common/init.sh"

get https://github.com/virtualsquare/vde-2/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf --disable-cryptcab --enable-pcap

make
make install DESTDIR="${D}"

finalize
