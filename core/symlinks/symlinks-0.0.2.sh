#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
"$FILESDIR/build.sh" "${D}/pkg/main/${PKG}.core.${PVR}"

mkdir "${D}/pkg/main/${PKG}.core.${PVR}/azusa"
cp "$FILESDIR/makeroot.sh" "${D}/pkg/main/${PKG}.core.${PVR}/azusa"


archive
