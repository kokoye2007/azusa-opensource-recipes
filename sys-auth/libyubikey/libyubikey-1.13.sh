#!/bin/sh
source "../../common/init.sh"

get http://opensource.yubico.com/yubico-c/releases/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
