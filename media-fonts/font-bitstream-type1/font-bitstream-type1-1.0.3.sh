#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/font/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
