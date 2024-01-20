#!/bin/sh
source "../../common/init.sh"

get https://ffmpeg.org/releases/${P}.tar.bz2
acheck

cd "${T}"

importpkg dev-libs/gmp media-sound/gsm media-sound/lame theora media-libs/xvid libgcrypt libmodplug icu-uc media-video/avisynth dev-util/nvidia-cuda-toolkit media-libs/nv-codec-headers

callconf --prefix=/pkg/main/${PKG}.core.${PVRF} \
	--libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX \
	--mandir=/pkg/main/${PKG}.doc.${PVRF}/man --docdir=/pkg/main/${PKG}.doc.${PVRF}/doc \
	--enable-gpl --enable-nonfree \
	--enable-shared --disable-static \
	--enable-avisynth --enable-gmp --enable-version3 --enable-gcrypt --enable-openssl --enable-libgsm --enable-libmp3lame --enable-libmodplug \
	--enable-libopencv --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libxvid \
	--enable-libxml2 --enable-libx265 --enable-libfreetype \
	--enable-cuvid --enable-libnpp --enable-ffnvcodec --enable-vaapi --enable-cuda-nvcc \
	--enable-libdav1d \
	--nvcc=/pkg/main/dev-util.nvidia-cuda-toolkit.core/bin/nvcc --nvccflags='-gencode arch=compute_80,code=sm_80 -O2 --compiler-bindir /pkg/main/sys-devel.gcc.core.12/bin/ -I /pkg/main/dev-util.nvidia-cuda-toolkit.dev/include' --enable-libnpp --enable-nvenc \
|| /bin/bash -i
#--enable-libass --enable-libbluray --enable-libdrm --enable-libkvazaar --enable-libxavs --enable-libxavs2
## --enable-librav1e fails because rust

make
make install DESTDIR="${D}"

finalize
