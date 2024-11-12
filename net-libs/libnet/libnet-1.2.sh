#!/bin/sh
source "../../common/init.sh"

get https://github.com/"${PN}"/"${PN}"/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
