#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"2/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
