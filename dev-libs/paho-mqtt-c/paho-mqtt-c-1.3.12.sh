#!/bin/sh
source "../../common/init.sh"

get https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

importpkg dev-libs/openssl

MAKEOPTS=(
	BUILD_TYPE=release
	prefix="/pkg/main/${PKG}.core.${PVRF}"
	libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	mandir="/pkg/main/${PKG}.doc.${PVRF}/man"
	includedir="/pkg/main/${PKG}.dev.${PVRF}/include"
)

mkdir -pv "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

make build "${MAKEOPTS[@]}"
make install DESTDIR="${D}" "${MAKEOPTS[@]}"

finalize
