#!/bin/sh
source "../../common/init.sh"

get https://ftp.pcre.org/pub/pcre/pcre-"${PV}".tar.bz2
acheck

cd "${T}" || exit

importpkg zlib app-arch/bzip2 sys-libs/readline

doconf --enable-unicode-properties --enable-shared --enable-pcre8 --enable-pcre16 --enable-pcre32 --enable-pcregrep-libz --enable-pcregrep-libbz2 --disable-static --enable-pcretest-libreadline

make
make install DESTDIR="${D}"

finalize
