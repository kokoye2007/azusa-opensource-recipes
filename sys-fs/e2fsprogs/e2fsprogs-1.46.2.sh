#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/"${PN}"/files/"${PN}"/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg uuid sys-apps/util-linux

doconf --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck

make
make install DESTDIR="${D}"

finalize
