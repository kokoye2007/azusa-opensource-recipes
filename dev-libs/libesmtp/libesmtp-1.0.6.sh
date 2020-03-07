#!/bin/sh
source "../../common/init.sh"

get http://brianstafford.info/libesmtp/${P}.tar.bz2

cd "${T}"

importpkg dev-libs/openssl

doconf --with-openssl=/pkg/main/dev-libs.openssl.dev

make
make install DESTDIR="${D}"

finalize
