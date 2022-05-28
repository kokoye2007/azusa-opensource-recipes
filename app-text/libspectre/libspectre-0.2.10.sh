#!/bin/sh
source "../../common/init.sh"

get https://libspectre.freedesktop.org/releases/${P}.tar.gz
acheck

cd "${S}"

importpkg app-text/ghostscript-gpl

doconf

make
make install DESTDIR="${D}"

finalize
