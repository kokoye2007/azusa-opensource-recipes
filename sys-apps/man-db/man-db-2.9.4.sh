#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/man-db/${P}.tar.xz
acheck

importpkg sys-libs/gdbm

cd ${T}

# configure & build
doconf --disable-setuid --enable-cache-owner=bin --with-browser=/bin/lynx --with-vgrind=/bin/vgrind --with-grap=/bin/grap --with-systemdtmpfilesdir= --with-systemdsystemunitdir=

make
make install DESTDIR="${D}"

finalize
