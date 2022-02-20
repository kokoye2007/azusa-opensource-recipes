#!/bin/sh
source "../../common/init.sh"

get https://github.com/fontforge/fontforge/releases/download/${PV}/fontforge-${PV}.tar.xz
acheck

cd "${T}"

importpkg libpng libjpeg media-libs/tiff media-libs/libspiro libuninameslist x11-base/xorg-proto x11-libs/libX11 x11-libs/gtk+ sys-libs/readline x11-libs/cairo media-libs/giflib freetype2

CMAKEOPTS=(
	-DENABLE_DOCS=OFF
	-DENABLE_LIBGIF=ON
	-DENABLE_LIBJPEG=ON
	-DENABLE_LIBPNG=ON
	-DENABLE_LIBREADLINE=ON
	-DENABLE_LIBSPIRO=OFF # todo?
	-DENABLE_LIBTIFF=ON
	-DENABLE_LIBUNINAMESLIST=ON
	-DENABLE_MAINTAINER_TOOLS=OFF
	-DENABLE_PYTHON_EXTENSION=ON
	-DENABLE_PYTHON_SCRIPTING=ON
	-DENABLE_TILE_PATH=ON
	-DENABLE_WOFF2=ON

	-DENABLE_GUI=ON
	-DENABLE_X11=OFF # prefer gtk
	-DPython3_EXECUTABLE="/bin/python3"
)

docmake "${CMAKEOPTS[@]}"

finalize
