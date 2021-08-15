#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/flac/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
