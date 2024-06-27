#!/bin/sh
source "../../common/init.sh"

get https://github.com/wxWidgets/wxWidgets/releases/download/v${PV}/wxWidgets-${PV}.tar.bz2
acheck

importpkg X zlib libpng libjpeg expat media-libs/mesa media-libs/glu media-libs/gstreamer

cd "${T}"

CONF=(
	--with-zlib=sys
	--with-expat=sys
	--enable-compat28
	--with-sdl

	# for X
	--enable-graphics_ctx
	--with-gtkprint
	--enable-gui
	--with-gtk=3
	--with-libpng=sys
	--with-libjpeg=sys
	--without-gnomevfs
	--enable-mediactrl
	--enable-webview
	--with-libnotify
	--with-opengl
	--with-libtiff=sys
)

doconf "${CONF[@]}"

make
make install DESTDIR="${D}"

finalize
