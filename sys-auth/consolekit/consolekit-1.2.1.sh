#!/bin/sh
source "../../common/init.sh"

get https://github.com/ConsoleKit2/ConsoleKit2/releases/download/${PV}/ConsoleKit2-${PV}.tar.bz2
acheck

#cd "${T}"
cd */

importpkg x11-base/xorg-proto x11-libs/libX11 zlib sys-libs/pam sys-apps/acl

doconf --enable-udev-acl --enable-pam-module --enable-polkit --with-xinitrc-dir=/etc/X11/app-defaults/xinitrc.d --without-systemdsystemunitdir --enable-docbook-docs --enable-libevdev --enable-libcgmanager --enable-libdrm --enable-libudev
# --enable-libselinux

make
make install DESTDIR="${D}"

finalize
