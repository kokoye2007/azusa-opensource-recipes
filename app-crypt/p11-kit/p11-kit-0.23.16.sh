#!/bin/sh
source "../../common/init.sh"

get https://github.com/p11-glue/"${PN}"/releases/download/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --without-systemd

make
make install DESTDIR="${D}"

finalize
