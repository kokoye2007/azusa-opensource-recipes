#!/bin/sh
source "../../common/init.sh"

get https://github.com/libsndfile/libsndfile/releases/download/${PV}/${P}.tar.bz2
acheck

cd "${T}"

importpkg media-libs/alsa-lib media-libs/opus

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
