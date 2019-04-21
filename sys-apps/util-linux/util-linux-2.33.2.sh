#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.33/${P}.tar.xz

cd "${T}"

doconf --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python --without-systemd --without-systemdsystemunitdir

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
