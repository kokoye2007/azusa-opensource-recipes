#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV%.*}-${PV##*.}"
get https://codeberg.org/smxi/${PN}/archive/${MY_PV}.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

# inxi  inxi.1  inxi.changelog  LICENSE.txt  README.txt

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v inxi "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"
mv -v inxi.1 "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"
mv -v inxi.changelog  LICENSE.txt  README.txt "${D}/pkg/main/${PKG}.doc.${PVRF}"

finalize
