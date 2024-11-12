#!/bin/sh
source "../../common/init.sh"

get https://libspectre.freedesktop.org/releases/"${P}".tar.gz
acheck

cd "${S}" || exit

importpkg app-text/ghostscript-gpl

doconf

make
make install DESTDIR="${D}"

finalize
