#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/libetonyek/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/boost media-libs/glm app-text/liblangtag

doconf --disable-werror --with-mdds=1.4 --disable-static --with-docs

make
make install DESTDIR="${D}"

finalize
