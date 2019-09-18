#!/bin/sh
source "../../common/init.sh"

get https://security.appspot.com/downloads/${P}.tar.gz

cd "${P}"

echo "#define VSF_BUILD_SSL" >>builddefs.h

make

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/sbin" "${D}/pkg/main/${PKG}.core.${PVR}/etc" "${D}/pkg/main/${PKG}.doc.${PVR}/man"/man{5,8}
install -v -m 755 vsftpd "${D}/pkg/main/${PKG}.core.${PVR}/sbin"
install -v -m 644 vsftpd.conf "${D}/pkg/main/${PKG}.core.${PVR}/etc"
install -v -m 644 vsftpd.8 "${D}/pkg/main/${PKG}.doc.${PVR}/man/man8"
install -v -m 644 vsftpd.conf.5 "${D}/pkg/main/${PKG}.doc.${PVR}/man/man5"

finalize
