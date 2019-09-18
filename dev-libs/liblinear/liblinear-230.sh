#!/bin/sh
source "../../common/init.sh"

get https://github.com/cjlin1/liblinear/archive/v${PV}/${P}.tar.gz

cd "${P}"

make lib

mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVR}/include" "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"

install -vm644 linear.h "${D}/pkg/main/${PKG}.dev.${PVR}/include"
install -vm755 liblinear.so.3 "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
ln -snfv liblinear.so.3 "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/liblinear.so"

finalize
