#!/bin/sh
source "../../common/init.sh"

get https://github.com/aria2/"${PN}"/releases/download/release-"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg gmp net-libs/libssh2

doconf --disable-xmltest --enable-libaria2 --with-libz --with-ca-bundle="" --enable-bittorrent --enable-metalink --enable-nls --with-libcares --without-jemalloc --with-libuv --with-sqlite3 --with-libssh2 --with-tcmalloc --without-openssl --with-gnutls --with-libnettle --without-libgcrypt --with-libgmp --without-libexpat --with-libxml2

make
make install DESTDIR="${D}"

finalize
