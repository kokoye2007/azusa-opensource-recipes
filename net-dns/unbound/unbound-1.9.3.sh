#!/bin/sh
source "../../common/init.sh"

get http://www.unbound.net/downloads/${P}.tar.gz

cd "${T}"

doconf --sysconfdir=/etc --disable-static --with-pidfile=/var/run/unbound.pid

make
make install DESTDIR="${D}"

finalize
