#!/bin/sh
source "../../common/init.sh"

get https://github.com/imageworks/OpenShadingLanguage/archive/Release-"${PV}"-dev.tar.gz "${P}.tar.gz"
acheck

cd "${T}" || exit

importpkg dev-libs/boost zlib media-libs/partio

# for some reason this is not autodetected
export pybind11_DIR="$(pybind11-config --cmakedir)"

docmake -DCMAKE_CXX_STANDARD=14 -DINSTALL_DOCS=YES -DLLVM_STATIC=OFF -DOSL_BUILD_TESTS=OFF -DSTOP_ON_WARNING=OFF -DUSE_PARTIO=ON -DUSE_QT=OFF

finalize
