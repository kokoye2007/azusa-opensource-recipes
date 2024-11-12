#!/bin/sh
source "../../common/init.sh"

get https://www.mpg123.org/download/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
