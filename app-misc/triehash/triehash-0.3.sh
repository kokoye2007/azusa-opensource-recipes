#!/bin/sh
source "../../common/init.sh"

get https://github.com/julian-klode/triehash/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v triehash.pl "${D}/pkg/main/${PKG}.core.${PVRF}/bin/triehash"
chmod -v +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/triehash"

finalize
