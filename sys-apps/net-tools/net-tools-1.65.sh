#!/bin/sh
source "../../common/init.sh"

get https://github.com/AzusaOS/${PN}/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${S}"

# go with the default options
yes '' | ./configure.sh config.in
make all
make installbin DESTDIR="${D}/pkg/main/${PKG}.core.${PVR}"
make -C man install BASEDIR="${D}" mandir="/pkg/main/${PKG}.doc.${PVR}"
make -C po install INSTALLNLSDIR="${D}/pkg/main/${PKG}.core.${PVR}/share/locale"

finalize
