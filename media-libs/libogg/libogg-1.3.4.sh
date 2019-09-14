#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/ogg/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
