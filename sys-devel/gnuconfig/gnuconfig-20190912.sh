#!/bin/sh
source "../../common/init.sh"

get https://dev.gentoo.org/~whissi/dist/${PN}/${P}.tar.bz2
acheck

apatch *.patch

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/share/${P}"

cp config.{sub,guess} "${D}/pkg/main/${PKG}.core.${PVR}/share/${P}"
chmod +x "${D}/pkg/main/${PKG}.core.${PVR}/share/${P}"/config.{sub,guess}

finalize
