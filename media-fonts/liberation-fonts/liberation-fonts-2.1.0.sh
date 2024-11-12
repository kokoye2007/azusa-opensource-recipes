#!/bin/sh
source "../../common/init.sh"

get https://github.com/liberationfonts/liberation-fonts/files/4178407/"${PN}"-ttf-"${PV}".tar.gz
acheck

cd "${S}" || exit

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVRF}"
mv -v *.ttf "${D}/pkg/main/${PKG}.fonts.${PVRF}"

finalize
