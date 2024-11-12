#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV%.*}"
get https://launchpad.net/apparmor/"${MY_PV}"/"${PV}"/+download/apparmor-"${PV}".tar.gz
acheck

S=${S}/libraries/${PN}

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
