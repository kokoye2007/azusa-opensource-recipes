#!/bin/sh
source "../../common/init.sh"

get https://github.com/jetmore/swaks/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp swaks "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
chmod +x "${D}/pkg/main/${PKG}.core.${PVRF}/bin/swaks"
sed -i -e '1 c#/pkg/main/sys-apps.coreutils.core/bin/env /pkg/main/dev-lang.perl.core/bin/perl' "${D}/pkg/main/${PKG}.core.${PVRF}/bin/swaks"

# TODO add documentation, etc

finalize
