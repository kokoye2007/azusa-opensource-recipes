#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/${P}.tar.xz
acheck

importpkg media-libs/lcms

cd "${T}"

doconf --disable-bash-completion --disable-examples --disable-static --enable-libcolordcompat --with-daemon-user=colord --enable-print-profiles --enable-gusb --enable-reverse --enable-introspection --enable-polkit --enable-sane --enable-udev --enable-vala --disable-systemd-login

make
make install DESTDIR="${D}"

finalize
