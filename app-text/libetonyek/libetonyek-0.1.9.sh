#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libetonyek/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost media-libs/glm

doconf --disable-werror --with-mdds=1.4 --disable-static --with-docs

make
make install DESTDIR="${D}"

finalize
