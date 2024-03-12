#!/bin/sh
source "../../common/init.sh"

get https://www.gnupg.org/ftp/gcrypt/gnupg/${P}.tar.bz2
acheck

cd "${T}"

importpkg net-libs/gnutls dev-libs/libgcrypt net-nds/openldap sys-libs/readline

doconf --enable-bzip2 --enable-nls --enable-scdaemon --enable-gnutls --enable-tofu --enable-keyboxd --enable-sqlite --with-tss=intel --disable-tpm2d --enable-wks-tools --with-ldap --with-readline --with-mailprog=/usr/libexec/sendmail --disable-ntbtls --enable-gpgsm --enable-large-secmem

make
make install DESTDIR="${D}"

finalize
