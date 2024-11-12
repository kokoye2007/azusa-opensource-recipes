#!/bin/sh
source "../../common/init.sh"

get http://"${PN}".twibright.com/download/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg sys-libs/gpm zlib app-arch/bzip2 app-arch/brotli dev-libs/libevent app-arch/lzma

doconflight --without-directfb --without-librsvg --with-brotli --with-bzip2 --with-fb --with-freetype --with-ipv6 --with-libjpeg --with-libevent --with-lzip --with-lzma --with-ssl --with-svgalib --with-libtiff --with-x --with-zlib --with-zstd

make
make install DESTDIR="${D}"

finalize
