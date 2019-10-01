#!/bin/sh
source "../../common/init.sh"

get https://github.com/qpdf/qpdf/releases/download/release-${P}/${P}.tar.gz
acheck

cd "${P}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
