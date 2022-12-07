#!/bin/sh
source "../../common/init.sh"

get http://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz

cd "${S}"
get https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-audacity.patch.bz2
bunzip2 ${P}-audacity.patch.bz2
apatch ${P}-audacity.patch

acheck

importpkg media-libs/alsa-lib

export CFLAGS="${CPPFLAGS} ${LDFLAGS} -O2"
export CXXFLAGS="${CPPFLAGS} ${LDFLAGS} -O2"


cd "${T}"

doconf --enable-cxx --disable-static --with-alsa

make
make install DESTDIR="${D}"

finalize
