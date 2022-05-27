#!/bin/sh
source "../../common/init.sh"

get https://www.libssh2.org/download/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib

docmake -DBUILD_SHARED_LIBS=ON -DCRYPTO_BACKEND=OpenSSL -DENABLE_ZLIB_COMPRESSION=TRUE

finalize
