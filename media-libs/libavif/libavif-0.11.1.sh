#!/bin/sh
source "../../common/init.sh"

get https://github.com/AOMediaCodec/libavif/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg X media-video/rav1e media-libs/libaom zlib libpng media-libs/libjpeg-turbo dev-libs/glib x11-libs/gdk-pixbuf

cd "${T}" || exit

CMAKEOPTS=(
	-DBUILD_SHARED_LIBS=ON
	-DAVIF_CODEC_AOM=ON
	-DAVIF_CODEC_DAV1D=ON
	-DAVIF_CODEC_LIBGAV1=OFF
	-DAVIF_LOCAL_ZLIBPNG=OFF

	# Use system libraries.
	-DAVIF_LOCAL_JPEG=OFF
	-DAVIF_BUILD_GDK_PIXBUF=ON

	-DAVIF_ENABLE_WERROR=OFF

	-DAVIF_CODEC_RAV1E=ON
	-DAVIF_CODEC_SVT=ON

	-DAVIF_BUILD_EXAMPLES=OFF
	-DAVIF_BUILD_APPS=ON
	-DAVIF_BUILD_TESTS=OFF
	-DAVIF_ENABLE_GTEST=OFF
)

docmake "${CMAKEOPTS[@]}"

finalize
