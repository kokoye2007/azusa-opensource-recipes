#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/boost

doconf

make
make install DESTDIR="${D}"

finalize
