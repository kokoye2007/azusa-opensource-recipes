#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/spice/"${PN}"/-/archive/"${P}"/"${PN}"-"${P}".tar.bz2
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
