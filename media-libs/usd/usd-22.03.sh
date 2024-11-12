#!/bin/sh
source "../../common/init.sh"

get https://github.com/PixarAnimationStudios/USD/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg X dev-libs/boost dev-cpp/tbb:2020 media-libs/mesa media-libs/opensubdiv dev-lang/python

docmake -DPXR_BUILD_IMAGING=OFF -DPXR_BUILD_USDVIEW=OFF -DPXR_USE_PYTHON_3=ON

finalize
