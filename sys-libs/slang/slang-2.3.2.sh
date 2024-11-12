#!/bin/sh
source "../../common/init.sh"

get https://www.jedsoft.org/releases/slang/"${P}".tar.bz2
acheck

cd "${P}" || exit

importpkg sys-libs/libtermcap-compat oniguruma ncurses libpcre zlib sys-libs/readline libpng

export CFLAGS="${CPPFLAGS} -O2"

doconf --with-readline=gnu --with-pcre --with-onig --with-png --with-z

make
make install DESTDIR="${D}"

finalize
