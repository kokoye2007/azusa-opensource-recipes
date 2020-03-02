#!/bin/sh
source "../../common/init.sh"

get https://developers.yubico.com/yubihsm-connector/Releases/${P}.tar.gz
acheck

cd "${P}"

make

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/bin"
install bin/yubihsm-connector "${D}/pkg/main/${PKG}.core.${PVR}/bin"

finalize
