#!/bin/sh
source "../../common/init.sh"

get http://dev-www.libreoffice.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/boost

doconf --disable-werror --with-docs --enable-tools

make
make install DESTDIR="${D}"

finalize
