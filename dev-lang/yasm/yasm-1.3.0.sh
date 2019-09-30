#!/bin/sh
source "../../common/init.sh"

get http://www.tortall.net/projects/yasm/releases/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
