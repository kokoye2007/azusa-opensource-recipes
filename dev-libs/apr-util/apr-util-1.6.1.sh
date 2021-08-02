#!/bin/sh
source "../../common/init.sh"

get http://ftp.riken.jp/net/apache/apr/${P}.tar.bz2
acheck

cd "${T}"

doconf --with-apr=`realpath /pkg/main/dev-libs.apr.core` --with-expat=`realpath /pkg/main/dev-libs.expat.dev`

make
make install DESTDIR="${D}"

finalize
