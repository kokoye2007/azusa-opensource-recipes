#!/bin/sh
source "../../common/init.sh"

get https://github.com/byuu/higan/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/${P}-make-install.patch"

cd "${S}/higan" || exit

importpkg X media-libs/mesa media-libs/alsa-lib media-libs/libao media-libs/openal media-sound/pulseaudio media-libs/libsdl2 libudev zlib

# provide flags & options ENV vars for build process
export flags="${CPPFLAGS} -O2"
export options="${LDFLAGS}"
export hiro=gtk3
export platform=linux
export prefix="/pkg/main/${PKG}.core.${PVR}"

make -j"$NPROC"
make install prefix="${D}$prefix"

# move systems
mkdir -p "${D}/pkg/main/${PKG}.data.${PVR}"
mv -Tv "${D}$prefix/share/higan" "${D}/pkg/main/${PKG}.data.${PVR}/higan"
ln -snfTv "/pkg/main/${PKG}.data.${PVR}/higan" "${D}$prefix/share/higan"

finalize
