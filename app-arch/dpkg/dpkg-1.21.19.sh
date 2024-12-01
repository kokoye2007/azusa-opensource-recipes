#!/bin/sh
source "../../common/init.sh"

get http://ftp.jp.debian.org/debian/pool/main/d/${PN}/${P/-/_}.tar.xz
acheck

cd "${T}"

importpkg ncurses zlib liblzma app-arch/bzip2 app-crypt/libmd sys-libs/libselinux dev-libs/libpcre2

doconf --enable-nls --disable-static --enable-unicode --enable-update-alternatives --with-libbz2 --with-liblzma --with-libz --disable-compiler-warnings --disable-dselect --disable-start-stop-daemon

make
make install DESTDIR="${D}"

finalize
