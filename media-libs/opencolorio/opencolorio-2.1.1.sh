#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg media-libs/ilmbase dev-cpp/pystring

CMAKEOPTS=(
	-DBUILD_SHARED_LIBS=ON
	-DOCIO_BUILD_DOCS=OFF # xxx fixme
	-DOCIO_BUILD_PYTHON=ON
	-DOCIO_BUILD_JAVA=OFF
	-DOCIO_BUILD_TESTS=OFF
	-DOCIO_BUILD_GPU_TESTS=OFF
	-DOCIO_BUILD_FROZEN_DOCS=OFF # xxx fixme
	-DOCIO_INSTALL_EXT_PACKAGES=NONE
)

if [ -d /pkg/main/media-libs.openimageio.core ]; then
	# openimageio is required to build apps, but typically openimageio requires this package
	CMAKEOPTS+=(-DOCIO_BUILD_APPS=ON)
fi

docmake "${CMAKEOPTS[@]}"

finalize
