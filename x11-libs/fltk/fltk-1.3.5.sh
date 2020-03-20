#!/bin/sh
source "../../common/init.sh"

get https://www.fltk.org/pub/fltk/${PV}/${P}-source.tar.bz2
acheck

cd "${P}"

importpkg X zlib libpng libjpeg fontconfig media-libs/mesa x11-libs/cairo x11-libs/pixman

CONF=(
	--enable-cairo
	--enable-gl
	--enable-threads
	--enable-xft
	--enable-xinerama
	--disable-localjpeg
	--disable-localpng
	--disable-localzlib
	--enable-largefile
	--enable-shared
	--enable-xcursor
	--enable-xdbe
	--enable-xfixes
	DSOFLAGS="${LDFLAGS}"
	LDFLAGS="${LDFLAGS}"
)

doconf "${CONF[@]}"

make -j"$NPROC"
make install DESTDIR="${D}"

# remove static libs
find "${D}" -name '*.a' -delete

finalize
