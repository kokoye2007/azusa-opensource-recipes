#!/bin/sh
source "../../common/init.sh"

get https://libbsd.freedesktop.org/releases/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg app-crypt/libmd

doconf

make
make install DESTDIR="${D}"

finalize
