#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.proftpd.org/distrib/source/${P}.tar.gz

cd "${P}"

patch -p1 <"$FILESDIR/proftpd-1.3.6-consolidated_fixes-1.patch"

doconf --sysconfdir=/etc --localstatedir=/var/run

make
make install DESTDIR="${D}"

finalize
