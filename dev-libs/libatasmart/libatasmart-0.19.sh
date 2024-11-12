#!/bin/sh
source "../../common/init.sh"

get http://0pointer.de/public/"${P}".tar.xz

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
