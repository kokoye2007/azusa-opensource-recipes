#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libtasn1/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
