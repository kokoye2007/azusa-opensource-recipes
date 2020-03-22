#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/vorbis/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
