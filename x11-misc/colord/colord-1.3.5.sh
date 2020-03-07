#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/${P}.tar.xz
acheck

importpkg media-libs/lcms

cd "${T}"

# TODO enable sane?
doconf --disable-bash-completion --disable-examples --disable-static --enable-libcolordcompat --with-daemon-user=colord --disable-print-profiles --enable-gusb --enable-reverse --enable-introspection --enable-polkit --disable-sane --enable-udev --enable-vala --disable-systemd-login --disable-argyllcms-sensor

make
make install DESTDIR="${D}"

finalize
