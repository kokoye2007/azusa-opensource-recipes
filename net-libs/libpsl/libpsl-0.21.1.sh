#!/bin/sh
source "../../common/init.sh"

get https://github.com/rockdaboot/libpsl/releases/download/"${P}"/"${P}".tar.gz
acheck

cd "${P}" || exit

sed -i 's/env python/&3/' src/psl-make-dafsa

cd "${T}" || exit

importpkg dev-libs/libunistring

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
