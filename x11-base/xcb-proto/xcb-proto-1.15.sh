#!/bin/sh
source "../../common/init.sh"

get https://xcb.freedesktop.org/dist/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make install DESTDIR="${D}"

finalize
