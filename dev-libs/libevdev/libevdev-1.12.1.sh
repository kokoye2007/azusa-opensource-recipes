#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/check

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
