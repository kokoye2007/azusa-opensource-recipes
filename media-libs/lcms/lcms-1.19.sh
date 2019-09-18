#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/${PN}/${P}.tar.gz

cd "${P}"

patch -p1 <"$FILESDIR/lcms-1.19-cve_2013_4276-1.patch"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
