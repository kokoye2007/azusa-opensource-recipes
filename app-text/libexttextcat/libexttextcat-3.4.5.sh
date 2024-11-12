#!/bin/sh
source "../../common/init.sh"

get http://dev-www.libreoffice.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
