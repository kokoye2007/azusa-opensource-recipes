#!/bin/sh
source "../../common/init.sh"

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

get http://download.librdf.org/source/${MY_P}.tar.gz
acheck

cd "${T}"

doconf --with-www=curl --with-html-dir="/pkg/main/${PKG}.doc.${PVRF}/html" --with-yajl --disable-static --with-icu-config=/bin/icu-config

make
make install DESTDIR="${D}"

finalize
