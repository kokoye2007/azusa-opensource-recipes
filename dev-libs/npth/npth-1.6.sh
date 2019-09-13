#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/${PN}/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
