#!/bin/sh
source "../../common/init.sh"

get https://download.gimp.org/mirror/pub/gimp/v${PV%.*}/${P}.tar.bz2
acheck

cd "${T}"

importpkg libjpeg media-libs/tiff zlib app-arch/bzip2 app-text/ghostscript-gpl

CONFOPTS=(
	#GEGL="${EPREFIX}"/usr/bin/gegl-0.4
	GDBUS_CODEGEN=/bin/false

	--enable-default-binary

	--disable-check-update
	--disable-python
	--enable-mp
	--with-appdata-test
	--with-bug-report-url=https://github.com/AzusaOS/azusa-opensource-recipes/issues
	--with-xmc
	--without-libbacktrace
	--without-webkit
	--without-xvfb-run

	--disable-debug
	--enable-vector-icons
	--with-aa
	--with-alsa
	--with-x
	--with-libheif
	--with-jpeg2000
	--with-libmng
	--with-openexr
	--with-gs
	--with-gudev
	--with-libunwind
	--with-webp
	--with-wmf
	--with-libxpm
)

doconf "${CONFOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
