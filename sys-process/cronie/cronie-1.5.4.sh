#!/bin/sh
source "../../common/init.sh"

get https://github.com/cronie-crond/cronie/releases/download/${P}-final/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-libs/pam

doconf --enable-syscrontab --enable-anacron --disable-silent-rules --with-inotify --with-pam

make
make install DESTDIR="${D}"

finalize
