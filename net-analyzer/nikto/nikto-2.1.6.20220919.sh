#!/bin/sh
source "../../common/init.sh"

fetchgit https://github.com/sullo/nikto.git fed0c5cab5ed00c4b8f07a781a8fcde25fe3bce2
acheck

cd "${S}" || exit

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}"
mv -v program "${D}/pkg/main/${PKG}.core.${PVRF}/nikto"

chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/nikto/nikto.pl"
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
ln -snf ../nikto/nikto.pl "${D}/pkg/main/${PKG}.core.${PVRF}/bin/nikto"

mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVRF}"
mv -v devdocs documentation README.md "${D}/pkg/main/${PKG}.doc.${PVRF}"

archive
