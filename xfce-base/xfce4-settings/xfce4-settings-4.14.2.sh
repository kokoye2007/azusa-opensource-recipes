#!/bin/sh
source "../../common/init.sh"

get http://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2
acheck

importpkg zlib x11-drivers/xf86-input-libinput sys-power/upower

cd "${T}"

doconf --enable-sound-settings --enable-pluggable-dialogs

make
make install DESTDIR="${D}"

finalize
