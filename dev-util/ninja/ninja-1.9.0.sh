#!/bin/sh
source "../../common/init.sh"

get https://github.com/ninja-build/ninja/archive/v${PV}.tar.gz

cd "${P}"

python3 configure.py --bootstrap

mkdir -p "${D}/pkg/main/${PKG}.${PVR}/bin"
install -vm755 ninja "${D}/pkg/main/${PKG}.${PVR}/bin"

finalize
