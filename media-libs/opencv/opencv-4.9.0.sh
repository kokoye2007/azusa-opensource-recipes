#!/bin/sh
source "../../common/init.sh"
inherit python

get https://github.com/opencv/"${PN}"/archive/"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${T}" || exit

importpkg zlib media-libs/openjpeg

# for python
PYTHON_EXE=$(realpath /pkg/main/dev-lang.python.core."$PYTHON_LATEST"/bin/python"${PYTHON_LATEST%.*}")
PYTHON_LIB=$(realpath /pkg/main/dev-lang.python.libs."$PYTHON_LATEST"/lib"$LIB_SUFFIX"/libpython"${PYTHON_LATEST%.*}".so)
PYTHON_INC=$(realpath /pkg/main/dev-lang.python.dev."$PYTHON_LATEST"/include/python"${PYTHON_LATEST%.*}")

OPTS=(
	-DBUILD_opencv_python2=OFF
	-DBUILD_opencv_python3=ON
	-DPYTHON3_EXECUTABLE=$PYTHON_EXE
	-DPYTHON3_LIBRARIES=$PYTHON_LIB
	-DPYTHON3_INCLUDE_DIRS=$PYTHON_INC

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
