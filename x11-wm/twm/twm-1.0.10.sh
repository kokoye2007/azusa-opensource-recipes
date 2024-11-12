#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/app/"${P}".tar.bz2

cd "${P}" || exit

sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
