#!/bin/sh
source "../../common/init.sh"

get https://github.com/projectatomic/"${PN}"/releases/download/v"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-libs/libcap sys-libs/libselinux

doconf

make
make install DESTDIR="${D}"

finalize
