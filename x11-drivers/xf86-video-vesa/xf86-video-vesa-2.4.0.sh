#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/driver/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
