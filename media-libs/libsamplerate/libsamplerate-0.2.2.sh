#!/bin/sh
source "../../common/init.sh"

get https://github.com/libsndfile/libsamplerate/releases/download/"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg media-libs/alsa-lib
doconf --disable-static

make
make install DESTDIR="${D}"

finalize
