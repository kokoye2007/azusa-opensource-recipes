#!/bin/sh
source "../../common/init.sh"

get https://xcb.freedesktop.org/dist/"${P}".tar.bz2

cd "${T}" || exit

doconf --localstatedir=/var --disable-static

make
make install DESTDIR="${D}"

finalize
