#!/bin/sh
source "../../common/init.sh"

if [[ "${PV}" =~ ^[[:digit:]]+\.0$ ]]; then
	SRC_URI="https://unicode.org/Public/${PN#*-}/${PV%.0}/${PN#*-}-common-${PV}.zip"
else
	SRC_URI="https://unicode.org/Public/${PN#*-}/${PV}/${PN#*-}-common-${PV}.zip"
fi

get "$SRC_URI"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/share/unicode/cldr"
mv common "${D}/pkg/main/${PKG}.core.${PVR}/share/unicode/cldr"

archive
