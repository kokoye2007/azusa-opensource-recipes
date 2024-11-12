#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/app/"${P}".tar.xz

cd "${T}" || exit

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
