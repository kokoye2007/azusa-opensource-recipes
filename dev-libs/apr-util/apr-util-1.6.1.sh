#!/bin/sh
source "../../common/init.sh"

get http://ftp.riken.jp/net/apache/apr/${P}.tar.bz2
acheck

importpkg expat

cd "${T}"

doconf --with-apr=`realpath /pkg/main/dev-libs.apr.core`

make
make install DESTDIR="${D}"

finalize
