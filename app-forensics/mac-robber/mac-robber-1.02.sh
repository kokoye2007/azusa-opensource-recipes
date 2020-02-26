#!/bin/sh
source "../../common/init.sh"

get http://prdownloads.sourceforge.net/mac-robber/${P}.tar.gz
acheck

cd "${P}"

make linux

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVR}/bin"
cp -v mac-robber "${D}/pkg/main/${PKG}.core.${PVR}/bin"

mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVR}"
cp -v CHANGES README "${D}/pkg/main/${PKG}.doc.${PVR}"

finalize
