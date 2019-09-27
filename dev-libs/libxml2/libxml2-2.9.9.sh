#!/bin/sh
source "../../common/init.sh"

get ftp://xmlsoft.org/libxml2/${P}.tar.gz

acheck

cd "${T}"

doconf --disable-maintainer-mode --disable-static --with-icu --without-python

make
make install DESTDIR="${D}"

finalize
