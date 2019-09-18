#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/bogofilter/${P}.tar.gz

cd "${T}"

doconf --sysconfdir=/etc/bogofilter

make
make install DESTDIR="${D}"

finalize
