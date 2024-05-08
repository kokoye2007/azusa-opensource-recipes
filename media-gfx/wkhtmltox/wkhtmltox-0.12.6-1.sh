#!/bin/sh
source "../../common/init.sh"

get https://github.com/wkhtmltopdf/packaging/releases/download/${PV}/wkhtmltox_${PV}.bionic_amd64.deb
acheck

ar x wkhtmltox_${PV}.bionic_amd64.deb
tar xvf data.tar.xz

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mv -v ./usr/local/bin/* "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
mv -v ./usr/local/lib/* "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
mv -v ./usr/local/include/wkhtmltox "${D}/pkg/main/${PKG}.dev.${PVRF}/include/wkhtmltox"

mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}"
mv -v ./usr/local/share/man "${D}/pkg/main/${PKG}.doc.${PVRF}/man"
mv -v ./usr/share/doc/wkhtmltox/changelog.gz "${D}/pkg/main/${PKG}.doc.${PVRF}"

finalize
