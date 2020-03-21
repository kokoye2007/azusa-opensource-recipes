#!/bin/sh
source "../../common/init.sh"

get https://github.com/byuu/higan/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}/higan"

importpkg X media-libs/mesa media-libs/alsa-lib media-libs/libao media-libs/openal media-sound/pulseaudio media-libs/libsdl2 libudev

# provide flags & options ENV vars for build process
export flags="${CPPFLAGS} -O2"
export options="${LDFLAGS}"

make platform="linux" hiro=gtk3
make install DESTDIR="${D}"

finalize
