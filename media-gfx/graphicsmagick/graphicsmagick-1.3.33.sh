#!/bin/sh
source "../../common/init.sh"

MY_P=${P/graphicsm/GraphicsM}
get https://download.sourceforge.net/"${PN}"/"${MY_P}".tar.xz
acheck

cd "${T}" || exit

importpkg X sys-devel/libtool zlib app-arch/zstd app-arch/bzip2 media-libs/libfpx app-arch/xz media-libs/lcms libpng libjpeg media-libs/tiff media-libs/libwebp libxml-2.0 media-libs/libwmf
# TODO jbig.h

CONFOPTS=(
	--enable-openmp
	--enable-largefile
	--enable-shared
	--disable-static
	--enable-magick-compat
	--with-threads
	--with-modules
	--with-quantum-depth=16
	--without-frozenpaths
	--with-magick-plus-plus
	--with-perl
	--with-perl-options=INSTALLDIRS=vendor
	--with-bzlib
	--without-dps # ?
	--with-fpx
	--with-jbig
	--with-webp
	--with-jpeg
	--without-jp2
	--with-lcms2
	--with-lzma
	--with-png
	--with-tiff
	--with-ttf
	--with-wmf

	# TODO fix paths
	--with-fontpath=/usr/share/fonts
	--with-gs-font-dir=/usr/share/fonts/urw-fonts
	--with-windows-font-dir=/usr/share/fonts/corefonts
	--with-xml
	--with-zlib
	--with-x
)

doconf "${CONFOPTS[@]}"

make
make perl-build

make install DESTDIR="${D}"
make -C PerlMagick DESTDIR="${D}" install

finalize
