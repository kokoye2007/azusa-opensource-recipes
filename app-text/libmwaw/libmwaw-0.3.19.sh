#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --enable-zip --disable-werror --disable-static --enable-tools

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
