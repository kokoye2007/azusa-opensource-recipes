#!/bin/sh
source "../../common/init.sh"

get https://github.com/unicode-org/cldr/archive/refs/tags/release-${PV/./-}.tar.gz "${P}.tar.gz"

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/share/unicode/cldr"
mv common "${D}/pkg/main/${PKG}.core.${PVRF}/share/unicode/cldr"

archive
