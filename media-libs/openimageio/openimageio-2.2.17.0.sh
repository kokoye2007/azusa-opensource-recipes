#!/bin/sh
source "../../common/init.sh"

get https://github.com/OpenImageIO/oiio/archive/refs/tags/v${PV}.tar.gz
acheck

PKGS=(
	dev-libs/boost
	zlib
	media-libs/tiff
	media-libs/libjpeg-turbo
	media-libs/giflib
	media-libs/opencv
	libpng
	dev-cpp/tbb
	app-arch/bzip2
	media-libs/freetype
	media-libs/opencolorio
	sci-libs/dcmtk
	media-libs/libheif
	media-libs/libraw
	media-libs/Field3D
	media-gfx/openvdb
	media-libs/ptex
	media-libs/libwebp
	media-libs/mesa
	dev-libs/libfmt
	dev-cpp/robin-map
)

importpkg "${PKGS[@]}"

cd "${T}"

CMAKEOPTS=(
	-DVERBOSE=ON
	-DOpenJPEG_ROOT=/pkg/main/media-libs.openjpeg.dev # somehow not picking up openjpeg via importpkg
	-DCMAKE_CXX_STANDARD=14 # OpenVDB 8.0+ requires C++14 or higher
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
	-DUSE_QT5=OFF ## XXX
	-DUSE_LIBRAW=ON
	-DUSE_FREETYPE=ON
	#-DPYTHON_SITE_DIR=
)

docmake "${CMAKEOPTS[@]}"

finalize
