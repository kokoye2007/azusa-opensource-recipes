#!/bin/sh
source "../../common/init.sh"

get https://github.com/ConsoleKit2/ConsoleKit2/archive/refs/tags/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

importpkg x11-base/xorg-proto x11-libs/libX11 zlib sys-libs/pam sys-apps/acl

export CPPFLAGS="${CPPFLAGS} -DPIE -fPIE"

doconf --enable-udev-acl --enable-pam-module --enable-polkit --with-xinitrc-dir=/etc/X11/app-defaults/xinitrc.d --without-systemdsystemunitdir --enable-docbook-docs --enable-libevdev --enable-libcgmanager --enable-libdrm --enable-libudev
# --enable-libselinux

make
make install DESTDIR="${D}"

finalize
