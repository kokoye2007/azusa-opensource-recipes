#!/bin/sh
source "../../common/init.sh"

get http://oligarchy.co.uk/xapian/${PV}/xapian-core-${PV}.tar.xz
acheck

cd "${T}"

importpkg zlib

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
