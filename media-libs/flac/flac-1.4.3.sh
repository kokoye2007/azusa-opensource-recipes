#!/bin/sh
source "../../common/init.sh"

get https://downloads.xiph.org/releases/flac/${P}.tar.xz
acheck

cd "${T}"

importpkg ogg

doconf

make
make install DESTDIR="${D}"

finalize
