#!/bin/sh
source "../../common/init.sh"

get https://security.appspot.com/downloads/"${P}".tar.gz

cd "${P}" || exit

echo "#define VSF_BUILD_SSL" >>builddefs.h

make

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/sbin" "${D}/pkg/main/${PKG}.core.${PVRF}/etc" "${D}/pkg/main/${PKG}.doc.${PVRF}/man"/man{5,8}
install -v -m 755 vsftpd "${D}/pkg/main/${PKG}.core.${PVRF}/sbin"
install -v -m 644 vsftpd.conf "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
install -v -m 644 vsftpd.8 "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man8"
install -v -m 644 vsftpd.conf.5 "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man5"

finalize
