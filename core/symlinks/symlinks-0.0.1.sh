#!/bin/sh
source "../../common/init.sh"

"$FILESDIR/build.sh" "${D}/pkg/main/${PKG}.${PVR}"

finalize

