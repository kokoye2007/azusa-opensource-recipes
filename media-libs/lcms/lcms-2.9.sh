#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/${PN}/lcms2-${PV}.tar.gz

cd "lcms2-${PV}"

sed -i '/AX_APPEND/s/^/#/' configure.ac
autoreconf

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
