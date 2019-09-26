#!/bin/sh
source "../../common/init.sh"

get https://ffmpeg.org/releases/${P}.tar.bz2

cd "${T}"

export CFLAGS="-I/pkg/main/dev-libs.gmp.dev/include -I/pkg/main/media-sound.gsm.dev/include -I/pkg/main/media-sound.lame.dev/include"
export LDFLAGS="-L/pkg/main/dev-libs.gmp.libs/lib$LIB_SUFFIX -L/pkg/main/media-sound.gsm.libs/lib$LIB_SUFFIX -L/pkg/main/media-sound.lame.libs/lib$LIB_SUFFIX"

callconf --prefix=/pkg/main/${PKG}.core.${PVR} \
	--libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
	--enable-gpl --enable-nonfree \
	--enable-shared --disable-static \
	--enable-avisynth --enable-gmp --enable-version3 --enable-gcrypt --enable-openssl --enable-libgsm --enable-libmp3lame --enable-libmodplug \
	--enable-libopencv --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libxvid \
	--enable-libxml2
#--enable-libass --enable-libbluray --enable-libdrm --enable-libkvazaar --enable-libx265 --enable-libxavs --enable-libxavs2

make
make install DESTDIR="${D}"

finalize
