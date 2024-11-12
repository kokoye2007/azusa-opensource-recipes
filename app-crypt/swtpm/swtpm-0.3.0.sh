#!/bin/sh
source "../../common/init.sh"

get https://github.com/stefanberger/swtpm/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

importpkg openssl dev-libs/libtpms

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

importpkg zlib

doconf --with-openssl --without-selinux --with-cuse --with-gnutls --with-seccomp

make
make install DESTDIR="${D}"

finalize
