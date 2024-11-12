#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/libmbim/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
