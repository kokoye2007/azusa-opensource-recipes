#!/bin/sh
source "../../common/init.sh"

get https://mujs.com/downloads/${P}.tar.gz
acheck

importpkg sys-libs/readline

cd "${S}"

make VERSION=${PV} prefix=/pkg/main/${PKG}.core.${PVRF} XCFLAGS="${CFLAGS}"  XCPPFLAGS="${CPPFLAGS}" shell shared
make DESTDIR="${D}" VERSION=${PV} prefix=/pkg/main/${PKG}.core.${PVRF} libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" install-shared

finalize
