#!/bin/sh
source "../../common/init.sh"

get https://github.com/liberationfonts/liberation-fonts/files/4178407/${PN}-ttf-${PV}.tar.gz
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVR}"
mv -v *.ttf "${D}/pkg/main/${PKG}.fonts.${PVR}"

finalize
