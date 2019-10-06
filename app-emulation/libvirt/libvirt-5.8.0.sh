#!/bin/sh
source "../../common/init.sh"

get https://libvirt.org/sources/${P}.tar.xz
acheck

cd "${T}"

doconf --with-qemu

make
make install DESTDIR="${D}"

finalize
