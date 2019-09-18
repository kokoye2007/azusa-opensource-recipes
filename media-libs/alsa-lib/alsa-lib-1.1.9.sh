#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.alsa-project.org/pub/lib/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
