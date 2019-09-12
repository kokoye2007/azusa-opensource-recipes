#!/bin/sh
source "../../common/init.sh"

get https://ftp.pcre.org/pub/pcre/pcre2-${PV}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
