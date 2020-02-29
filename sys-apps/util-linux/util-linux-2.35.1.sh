#!/bin/sh
cd "$(dirname $0)"
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.35/${P}.tar.xz
acheck

cd "${T}"

# ncurses for -ltinfo
importpkg libpcre2-8 sys-libs/ncurses

# libdir needs to start with $prefix in order to avoid weird bugs

doconf --libdir=/pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX \
	--disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static \
	--without-python --without-systemd --without-systemdsystemunitdir

make
make install DESTDIR="${D}"

finalize
