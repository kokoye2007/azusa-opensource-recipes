#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/${PN}/files/${PN}/v${PV}/${P}.tar.gz

cd "${T}"

doconf --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
