#!/bin/sh
source "../../common/init.sh"

get https://archive.mozilla.org/pub/nspr/releases/v${PV}/src/${P}.tar.gz

cd "${P}/${PN}"

doconf --enable-64bit

make
make install DESTDIR="${D}"

finalize
