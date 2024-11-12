#!/bin/sh
source "../../common/init.sh"

get https://www.prelude-siem.org/attachments/download/1176/"${P}".tar.gz
acheck

cd "${S}" || exit

importpkg icu-uc

# build with system libev seems broken
#importpkg dev-libs/libev
#export LIBEV_CFLAGS="-I/pkg/main/dev-libs.libev.dev/include"
#export LIBEV_LIBS="-L/pkg/main/dev-libs.libev.libs/lib$LIB_SUFFIX -lev"

doconf #--with-libev

make
make install DESTDIR="${D}"

finalize
