#!/bin/sh
source "../../common/init.sh"

get https://github.com/PixarAnimationStudios/OpenSubdiv/archive/v${PV//./_}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/opensubdiv-3.4.4-add-CUDA11-compatibility.patch" "$FILESDIR/opensubdiv-3.4.4-tbb-2021.patch"

cd "${T}"

importpkg X dev-cpp/tbb media-libs/mesa dev-util/nvidia-cuda-toolkit media-libs/ptex zlib media-libs/glfw

# note: opencl fails to build
docmake -DNO_CLEW=ON -DNO_OPENCL=ON -DNO_DOC=ON -DNO_TUTORIALS=ON -DNO_REGRESSION=ON

finalize
