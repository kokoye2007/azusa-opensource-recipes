#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.unixodbc.org/pub/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconf --sysconfdir="/etc/${PN}" --disable-static --enable-iconv --enable-shared --disable-static --enable-drivers --enable-driverc --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE

make
make install DESTDIR="${D}"

finalize
