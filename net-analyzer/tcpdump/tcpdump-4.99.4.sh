#!/bin/sh
source "../../common/init.sh"

get https://www.tcpdump.org/release/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
