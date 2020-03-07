#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/"
cd "${D}/pkg/main/"

#get https://handshake.org/files/${P}.tar.gz
get https://github.com/handshake-org/hsd/archive/v${PV}.tar.gz
acheck

mv "$P" "${PKG}.core.${PVR}"
rm -f "v${PV}.tar.gz"

importpkg libunbound

cd "${PKG}.core.${PVR}"

npm install --production

finalize
