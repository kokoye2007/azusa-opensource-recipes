#!/bin/sh
source "../../common/init.sh"

get https://bitbucket.org/multicoreware/x265/downloads/x265_${PV}.tar.gz

cd "${T}"

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DENABLE_HDR10_PLUS=ON -DHIGH_BIT_DEPTH=ON -DLIB_INSTALL_DIR=lib$LIB_SUFFIX -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}"/*/source
# -DENABLE_SVT_HEVC=ON -DENABLE_LIBVMAF=ON

make
make install DESTDIR="${D}"

finalize
