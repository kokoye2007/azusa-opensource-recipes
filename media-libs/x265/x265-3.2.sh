#!/bin/sh
source "../../common/init.sh"

get https://bitbucket.org/multicoreware/x265/downloads/x265_${PV}.tar.gz
acheck

cd "${T}"

# we add CMAKE_LIBRARY_PATH so cmake can find -ldl
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=ON -DENABLE_HDR10_PLUS=ON -DHIGH_BIT_DEPTH=ON -DLIB_INSTALL_DIR=lib$LIB_SUFFIX -DCMAKE_LIBRARY_PATH=/pkg/main/sys-libs.glibc.libs/lib$LIB_SUFFIX -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}"/*/source
# -DENABLE_SVT_HEVC=ON -DENABLE_LIBVMAF=ON

make
make install DESTDIR="${D}"

finalize
