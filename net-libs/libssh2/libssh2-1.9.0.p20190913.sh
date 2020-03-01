#!/bin/sh
source "../../common/init.sh"

EGIT_COMMIT=336bd86d2ca4030b808d76e56a0387914982e289
get https://github.com/libssh2/libssh2/archive/${EGIT_COMMIT}.tar.gz
acheck

cd "${T}"

CMAKE_ROOT="$CHPATH/libssh2-$EGIT_COMMIT"
docmake -DBUILD_SHARED_LIBS=ON -DCRYPTO_BACKEND=OpenSSL -DENABLE_ZLIB_COMPRESSION=TRUE

make
make install DESTDIR="${D}"

finalize
