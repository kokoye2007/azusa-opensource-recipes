#!/bin/sh
source "../../common/init.sh"

get https://github.com/OpenImageIO/oiio/archive/refs/tags/v${PV}.tar.gz
acheck

importpkg dev-libs/boost zlib media-libs/tiff media-libs/libjpeg-turbo media-libs/giflib media-libs/opencv libpng dev-cpp/tbb app-arch/bzip2 media-libs/freetype

cd "${T}"

CMAKEOPTS=(
	-DVERBOSE=ON
	-DOIIO_BUILD_TESTS=OFF
	-DINSTALL_FONTS=ON
	-DBUILD_DOCS=OFF # fix
	-DINSTALL_DOCS=OFF # fix
	-DSTOP_ON_WARNING=OFF
	-DUSE_CCACHE=OFF
	-DUSE_DCMTK=ON
	-DUSE_EXTERNAL_PUGIXML=ON
	-DUSE_JPEGTURBO=ON
	-DUSE_NUKE=OFF # ??
	-DUSE_FFMPEG=ON
	-DUSE_FIELD3D=ON
	-DUSE_GIF=ON
	-DUSE_OPENJPEG=ON
	-DUSE_OPENCV=ON
	-DUSE_OPENGL=ON
	-DUSE_OPENVDB=ON
	-DUSE_PTEX=ON
	-DUSE_PYTHON=ON
	-DUSE_QT=OFF ## XXX
	-DUSE_LIBRAW=ON
	-DUSE_FREETYPE=ON
	#-DPYTHON_SITE_DIR=
)

docmake "${CMAKEOPTS[@]}"

finalize
