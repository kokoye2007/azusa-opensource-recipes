#!/bin/sh
source "../../common/init.sh"

get https://download.samba.org/pub/rsync/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
