#!/bin/sh
source "../../common/init.sh"

get http://releases.llvm.org/${PV}/${P}.src.tar.xz
acheck

cd "${T}"

# see http://llvm.org/docs/CMake.html

cmake ${CHPATH}/${P}.src -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR}

make
make install DESTDIR="${D}"

finalize
