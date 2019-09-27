#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/${PN}/${P}.tar.bz2

acheck

cd "${T}"

doconf --enable-threads=posix --disable-static --disable-tests

make
make install DESTDIR="${D}"

finalize
