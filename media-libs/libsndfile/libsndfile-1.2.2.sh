#!/bin/sh
source "../../common/init.sh"

get https://github.com/libsndfile/libsndfile/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg media-libs/alsa-lib media-libs/opus media-sound/lame

doconf --disable-static --disable-octave --disable-werror --enable-external-libs --enable-mpeg --enable-full-suite --enable-alsa --enable-sqlite

make
make install DESTDIR="${D}"

finalize
