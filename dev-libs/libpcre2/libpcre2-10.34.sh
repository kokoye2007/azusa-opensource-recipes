#!/bin/sh
source "../../common/init.sh"

get https://ftp.pcre.org/pub/pcre/pcre2-${PV}.tar.bz2
acheck

importpkg zlib app-arch/bzip2

cd "${T}"

doconf --enable-unicode --enable-jit --enable-pcre2-16 --enable-pcre2-32 --enable-pcre2grep-libz --enable-pcre2grep-libbz2 --disable-static
#--enable-pcre2test-libreadline

make
make install DESTDIR="${D}"

finalize
