#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/bogofilter/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-libs/db

doconf --sysconfdir=/etc/bogofilter

make
make install DESTDIR="${D}"

finalize
