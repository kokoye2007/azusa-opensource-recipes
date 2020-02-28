#!/bin/sh
source "../../common/init.sh"

get https://www.jedsoft.org/releases/slang/${P}.tar.bz2
acheck

cd "${P}"

importpkg sys-libs/libtermcap-compat oniguruma ncurses libpcre zlib

export CFLAGS="-O2"

doconf

make
make install DESTDIR="${D}"

finalize
