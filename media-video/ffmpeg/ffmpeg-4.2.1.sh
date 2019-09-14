#!/bin/sh
source "../../common/init.sh"

get https://ffmpeg.org/releases/${P}.tar.bz2

cd "${T}"

callconf --prefix=/pkg/main/${PKG}.core.${PVR} \
	--libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX \
	--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
	--enable-gpl --enable-nonfree \
	--enable-shared --disable-static \
	--enable-avisynth --enable-gmp --enable-version3 --enable-gcrypt --enable-openssl --enable-libgsm --enable-libmp3lame \
	--enable-libopencv --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxavs --enable-libxavs2 --enable-libxvid \
	--enable-libxml2
#--enable-libass --enable-libbluray --enable-libdrm --enable-libkvazaar --enable-libmodplug

make
make install DESTDIR="${D}"

finalize
