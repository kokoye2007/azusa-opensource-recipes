#!/bin/sh
source "../../common/init.sh"

get http://webdav.org/neon/${P}.tar.gz
acheck

importpkg expat zlib

cd "${T}"

doconf --enable-threadsafe-ssl=posix --with-expat --with-ssl=openssl --enable-shared --with-libproxy --enable-nls --disable-static --with-zlib

make
make install DESTDIR="${D}"

finalize
