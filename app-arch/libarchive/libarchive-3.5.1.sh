#!/bin/sh
source "../../common/init.sh"

get https://www.libarchive.org/downloads/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib app-arch/bzip2 app-arch/zstd dev-libs/lzo app-arch/lz4 app-arch/xz-utils dev-libs/nettle

doconf --disable-static --with-lzo2 --with-nettle

make
make install DESTDIR="${D}"

finalize
