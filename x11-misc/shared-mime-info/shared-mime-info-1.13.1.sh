#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/5349e18c86eb96eee258a5c1f19122d0/"${P}".tar.xz

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
