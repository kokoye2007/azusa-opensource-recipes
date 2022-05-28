#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/enlightenment/${P}.tar.xz
acheck

cd "${T}"

importpkg X media-libs/giflib app-arch/bzip2 media-libs/libjxl

CONFOPTS=(
	--with-x
	--with-bz2
	--with-gif
	--with-jpeg
	#--with-id3
	--with-png
	--with-x-shm-fd
	--enable-static
	--with-tiff
	--with-webp
	--with-zlib
	--with-svg
	--with-heif
	--with-ps
	--with-j2k
	--with-jxl
)

if [ x"$ARCH" = x"amd64" ]; then
	CONFOPTS+=(--enable-amd64 --disable-mmx)
else
	CONFOPTS+=(--disable-amd64)
fi
if [ x"$ARCH" = x"386" ]; then
	CONFOPTS+=(--enable-mmx)
fi

doconf "${CONFOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
