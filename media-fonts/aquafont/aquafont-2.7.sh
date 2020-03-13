#!/bin/sh
source "../../common/init.sh"

MY_P="${PN/font/}${PV/\./_}"
get http://www.geocities.jp/teardrops_in_aquablue/fnt/${MY_P}.zip
acheck

cd "${S}"

mkdir -pv "${D}/pkg/main/${PKG}.fonts.${PVR}/ttf" "${D}/pkg/main/${PKG}.doc.${PVR}/"

cp -v *.ttf "${D}/pkg/main/${PKG}.fonts.${PVR}/ttf"

# copy readme, convert to UTF-8
cat readme.txt | iconv -f SJIS -t UTF-8 > "${D}/pkg/main/${PKG}.doc.${PVR}/readme.txt"

finalize
