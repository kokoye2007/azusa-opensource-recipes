#!/bin/sh
source "../../common/init.sh"

mkdir -p "${D}/pkg/main/${PKG}.${PVR}"
"$FILESDIR/build.sh" "${D}/pkg/main/${PKG}.${PVR}"

mkdir "${D}/pkg/main/${PKG}.${PVR}/azusa"
cp "$FILESDIR/makeroot.sh" "${D}/pkg/main/${PKG}.${PVR}/azusa"


finalize
