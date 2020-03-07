#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/"
cd "${D}/pkg/main/"

get https://github.com/handshake-org/${PN}/archive/v${PV}.tar.gz
acheck

mv "$P" "${PKG}.mod.${PVR}"
rm -f "v${PV}.tar.gz"

importpkg libunbound

cd "${PKG}.mod.${PVR}"

npm install --production

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/bin"

# only expose hsd and hsw
for bin in hsd hsw; do
	ln -snfTv "/pkg/main/${PKG}.mod.${PVR}/bin/$bin" "${D}/pkg/main/${PKG}.core.${PVR}/bin/$bin"
done

archive
