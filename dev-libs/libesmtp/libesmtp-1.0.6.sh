#!/bin/sh
source "../../common/init.sh"

get http://brianstafford.info/libesmtp/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
