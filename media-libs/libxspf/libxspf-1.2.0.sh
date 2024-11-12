#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/xspf/"${P}".tar.bz2
acheck

cd "${S}" || exit

apatch "${FILESDIR}/${P}"-*.patch

cd "${T}" || exit

importpkg expat dev-libs/uriparser

doconf

make
make install DESTDIR="${D}"

finalize
