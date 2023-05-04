#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/${PN}/archive/${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg zlib media-libs/openjpeg

OPTS=(
	-DPYTHON_EXECUTABLE=OFF
	-DINSTALL_PYTHON_EXAMPLES=OFF
	-DBUILD_opencv_python2=OFF
	-DBUILD_opencv_python3=OFF

	-DBUILD_SHARED_LIBS=ON
	-DOPENCV_GENERATE_PKGCONFIG=YES

	-DENABLE_DOWNLOAD=OFF
	-DWITH_QUIRC=OFF
	-DWITH_EIGEN=ON
	-DWITH_FFMPEG=ON
	-DWITH_OPENJPEG=OFF # openjpeg cmake file is broken
	# TODO
)

docmake "${OPTS[@]}"

finalize
