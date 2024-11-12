#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/"
cd "${D}/pkg/main/" || exit

get https://github.com/handshake-org/"${PN}"/archive/v"${PV}".tar.gz
acheck

mv "$P" "${PKG}.data.${PVRF}"
rm -f "v${PV}.tar.gz"

importpkg libunbound

cd "${PKG}.data.${PVRF}" || exit

npm install --production

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

# only expose hsd and hsw
for bin in hsd hsw; do
	ln -snfTv "/pkg/main/${PKG}.data.${PVRF}/bin/$bin" "${D}/pkg/main/${PKG}.core.${PVRF}/bin/$bin"
done

archive
