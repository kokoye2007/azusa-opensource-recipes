#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/lib/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --localstatedir=/var --disable-static

make
make install DESTDIR="${D}"

finalize
