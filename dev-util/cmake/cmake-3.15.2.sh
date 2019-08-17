#!/bin/sh
source "../../common/init.sh"

get https://github.com/Kitware/CMake/releases/download/v${PV}/${P}.tar.gz

cd "${T}"

# configure & build
callconf --no-qt-gui --prefix=/pkg/main/${PKG}.core.${PVR} --mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc

make
make install DESTDIR="${D}"

finalize
