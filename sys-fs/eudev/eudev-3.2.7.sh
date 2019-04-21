#!/bin/sh
source "../../common/init.sh"

get https://dev.gentoo.org/~blueness/eudev/${P}.tar.gz

cd "${T}"

doconf --enable-manpages --disable-static --config-cache

make
make install DESTDIR="${D}"

cd "$D"
mv etc "pkg/main/${PKG}.core.${PVR}"

finalize
