#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/bluetooth/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-fs/eudev sys-libs/readline dev-libs/libical

doconf --sysconfdir=/etc --localstatedir=/var --enable-library --disable-systemd

make
make install DESTDIR="${D}"

finalize
