#!/bin/sh
source "../../common/init.sh"

get http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
get https://sources.debian.org/data/main/p/portaudio19/19.6.0-1/debian/patches/audacity-portmixer.patch "${PN}-19.06.00-audacity-portmixer.patch"
acheck

importpkg media-libs/alsa-lib

export CFLAGS="${CPPFLAGS} ${LDFLAGS} -O2"
export CXXFLAGS="${CPPFLAGS} ${LDFLAGS} -O2"

cd "${S}"

apatch ../${PN}-19.06.00-audacity-portmixer.patch

cd "${T}"

doconf --enable-cxx --disable-static --with-alsa

make
make install DESTDIR="${D}"

finalize
