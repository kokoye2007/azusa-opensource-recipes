#!/bin/sh
source "../../common/init.sh"

get https://github.com/ninja-build/ninja/archive/v${PV}.tar.gz
acheck

cd "${P}"

python3 configure.py --bootstrap

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
install -vm755 ninja "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
