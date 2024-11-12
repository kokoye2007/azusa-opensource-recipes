#!/bin/sh
source "../../common/init.sh"

get https://github.com/harfbuzz/harfbuzz/releases/download/"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --with-gobject --with-graphite2 --disable-static

make
make install DESTDIR="${D}"

finalize
