#!/bin/sh
source "../../common/init.sh"

get https://github.com/fontforge/"${PN}"/releases/download/"${PV}"/"${PN}"-dist-"${PV}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-static --enable-frenchlib

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
