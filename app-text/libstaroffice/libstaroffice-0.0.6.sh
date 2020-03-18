#!/bin/sh
source "../../common/init.sh"

get http://dev-www.libreoffice.org/src/${P}.tar.xz
acheck

cd "${T}"

doconf --disable-werror --with-docs --enable-tools --enable-zip

make
make install DESTDIR="${D}"

finalize
