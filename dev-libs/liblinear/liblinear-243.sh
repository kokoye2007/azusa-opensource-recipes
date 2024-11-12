#!/bin/sh
source "../../common/init.sh"

get https://github.com/cjlin1/liblinear/archive/v"${PV}"/"${P}".tar.gz
acheck

cd "${P}" || exit

make lib

mkdir -pv "${D}/pkg/main/${PKG}.dev.${PVRF}/include" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

install -vm644 linear.h "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
install -vm755 liblinear.so.4 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
ln -snfv liblinear.so.4 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/liblinear.so"

finalize
