#!/bin/sh
source "../../common/init.sh"

get http://wgetpaste.zlin.dk/"${P}".tar.bz2
acheck

cd "${S}" || exit

PATCHES=( "${FILESDIR}/${P}-fix-bpaste.patch" )
apatch "${PATCHES[@]}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv "${PN}" "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
