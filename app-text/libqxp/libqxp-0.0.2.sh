#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/boost

doconf --disable-weffc --with-docs --disable-tests --enable-tools

make
make install DESTDIR="${D}"

finalize
