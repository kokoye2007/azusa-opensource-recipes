#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libfreehand/"${P}".tar.xz
acheck

cd "${S}" || exit

apatch "$FILESDIR"/"${P}"-*.patch

cd "${T}" || exit

importpkg dev-libs/boost

doconf --disable-werror --with-docs --disable-static

make
make install DESTDIR="${D}"

finalize
