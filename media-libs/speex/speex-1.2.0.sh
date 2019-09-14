#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/speex/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
