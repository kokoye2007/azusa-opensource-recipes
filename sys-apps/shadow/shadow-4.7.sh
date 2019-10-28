#!/bin/sh
source "../../common/init.sh"

get https://github.com/shadow-maint/shadow/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

# configure & build
doconf --without-group-name-max-length --without-tcb --enable-shared=no --enable-static=yes --with-libpam --with-libcrack --with-acl --enable-nls

make
make install DESTDIR="${D}"

finalize
