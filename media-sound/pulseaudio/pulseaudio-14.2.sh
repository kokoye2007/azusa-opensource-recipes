#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-devel/libtool sys-libs/libcap dev-libs/check dev-libs/libbsd zlib net-dns/avahi x11-libs/libxcb

export LIBSPEEX_CFLAGS="$(pkg-config --cflags speex speexdsp)"
export LIBSPEEX_LIBS="$(pkg-config --libs speex speexdsp)"

doconf --sysconfdir=/etc --localstatedir=/var --disable-bluez4 --disable-bluez5 --disable-rpath --with-systemduserunitdir=no

make
make install DESTDIR="${D}"

finalize
