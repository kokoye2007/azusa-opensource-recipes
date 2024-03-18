#!/bin/sh
source "../../common/init.sh"

get https://github.com/brailcom/speechd/releases/download/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-devel/libtool app-accessibility/espeak app-accessibility/flite media-libs/libsndfile dev-libs/dotconf

doconf --disable-python --disable-static --with-baratinoo=no --with-ibmtts=no --with-kali=no --with-alsa --with-libao --with-espeak --with-flite --with-pulse

make
make install DESTDIR="${D}"

# python in src/api/python

finalize
