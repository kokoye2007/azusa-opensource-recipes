#!/bin/sh
source "../../common/init.sh"

get http://ftp.ntua.gr/pub/net/mail/imap/imap-${PV}.tar.gz
acheck

cd "imap-${PV}"

patch -p1 -i "$FILESDIR/c-client-2006k_GENTOO_amd64-so-fix.patch"
patch -p1 -i "$FILESDIR/c-client-2007f-openssl-1.1.patch"

importpkg sys-libs/pam openssl

# prevent warning about ipv6
touch ip6 sslunix

# lnp?
make slx EXTRACFLAGS="$CPPFLAGS -fPIC -I/pkg/main/dev-libs.openssl.dev/include/openssl" SSLTYPE=unix SHLIBBASE=c-client SHLIBNAME=libc-client.so.1 IP=6 SSLDIR=/etc/ssl SSLLIB=/pkg/main/dev-libs.openssl.libs/lib$LIB_SUFFIX
#make an build BUILDTYPE=lnp EXTRACFLAGS="$CPPFLAGS -I/pkg/main/dev-libs.openssl.dev/include/openssl"

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
install -v -m 755 c-client/libc-client.so.1.0.0 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
ln -snfv libc-client.so.1.0.0 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libc-client.so.1"
ln -snfv libc-client.so.1.0.0 "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/libc-client.so"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/include/imap"
install -v -m 644 ./c-client/*.h "${D}/pkg/main/${PKG}.dev.${PVRF}/include/imap"
install -v -m 644 ./c-client/linkage.c "${D}/pkg/main/${PKG}.dev.${PVRF}/include/imap"
install -v -m 644 ./src/osdep/tops-20/shortsym.h "${D}/pkg/main/${PKG}.dev.${PVRF}/include/imap"


finalize
