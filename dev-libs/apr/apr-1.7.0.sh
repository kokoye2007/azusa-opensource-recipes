#!/bin/sh
source "../../common/init.sh"

get http://ftp.riken.jp/net/apache/${PN}/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
