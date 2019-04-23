#!/bin/sh
source "../../common/init.sh"

if [ `id -u` -neq 0 ]; then
	echo "This needs to be compiled as root because reasons"
	exit 1
fi

get https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.33/${P}.tar.xz

cd "${T}"

doconf --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python --without-systemd --without-systemdsystemunitdir

make
make install DESTDIR="${D}"

finalize
