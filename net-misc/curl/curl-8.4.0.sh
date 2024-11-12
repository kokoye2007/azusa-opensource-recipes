#!/bin/sh
source "../../common/init.sh"

get https://curl.haxx.se/download/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg libbrotlidec app-arch/zstd net-libs/libssh2

doconf --with-openssl --with-libssh2 --enable-websockets

make
make install DESTDIR="${D}"

finalize
