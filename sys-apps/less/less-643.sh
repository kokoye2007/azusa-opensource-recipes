#!/bin/sh
source "../../common/init.sh"

get http://www.greenwoodsoftware.com/less/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-libs/ncurses

doconf

make
make install DESTDIR="${D}"

finalize
