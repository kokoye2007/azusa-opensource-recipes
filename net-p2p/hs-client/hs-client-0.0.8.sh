#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/"
cd "${D}/pkg/main/"

get https://github.com/handshake-org/${PN}/archive/v${PV}.tar.gz
acheck

mv "$P" "${PKG}.core.${PVR}"
rm -f "v${PV}.tar.gz"

importpkg libunbound

cd "${PKG}.core.${PVR}"

npm install --production

finalize
