#!/bin/sh
source "../../common/init.sh"

get http://invisible-mirror.net/archives/lynx/tarballs/lynx"${PV}".tar.bz2
acheck

cd "lynx${PV}" || exit

doconflight --enable-nested-tables --enable-cgi-links --enable-persistent-cookies --enable-prettysrc --enable-nsl-fork --enable-file-upload --enable-read-eta --enable-color-style --enable-scrollbar --enable-included-msgs --enable-externs --with-zlib --enable-nls --enable-idna --enable-ipv6 --enable-cjk --enable-japanese-utf8 --enable-bzlib --with-ssl=/pkg/main/dev-libs.openssl.dev --with-screen=ncursesw

make -C po -j1
make
make install DESTDIR="${D}"

finalize
