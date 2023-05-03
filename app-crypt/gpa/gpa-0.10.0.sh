#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/${PN}/${P}.tar.bz2
get https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-autoconf.patch.xz
acheck

cd "${T}"

importpkg zlib

# GPGKEYS_LDAP="/usr/libexec/gpgkeys_ldap" ?

doconf

make
make install DESTDIR="${D}"

finalize
