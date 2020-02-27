#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/software/scm/git/${P}.tar.xz
acheck

cd "${P}"

importpkg zlib openssl libpcre2-8 libcurl expat

# configure & build
doconf --with-libpcre2

make
make install DESTDIR="${D}"

finalize
