#!/bin/sh
source "../../common/init.sh"

get http://www.freebsoft.org/pub/projects/speechd/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-devel/libtool app-accessibility/espeak app-accessibility/flite

doconf --disable-python --disable-static --with-alsa --with-libao --with-espeak --with-flite --with-pulse

make
make install DESTDIR="${D}"

# python in src/api/python

finalize
