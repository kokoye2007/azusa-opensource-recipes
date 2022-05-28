#!/bin/sh
source "../../common/init.sh"

get https://github.com/ChainSafe/ChainBridge/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
envcheck

cd "${S}"

make build

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp -av build/chainbridge "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize

