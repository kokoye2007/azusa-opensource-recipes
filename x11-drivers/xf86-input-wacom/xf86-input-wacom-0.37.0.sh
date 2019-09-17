#!/bin/sh
source "../../common/init.sh"

get https://github.com/linuxwacom/xf86-input-wacom/releases/download/${P}/${P}.tar.bz2

cd "${T}"

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
