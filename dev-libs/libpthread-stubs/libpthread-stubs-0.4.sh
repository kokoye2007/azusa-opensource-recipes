#!/bin/sh
source "../../common/init.sh"

get https://xcb.freedesktop.org/dist/"${P}".tar.bz2

cd "${T}" || exit

doconf

make install DESTDIR="${D}"

finalize
