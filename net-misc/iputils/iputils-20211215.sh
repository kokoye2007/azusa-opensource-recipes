#!/bin/sh
source "../../common/init.sh"

get https://github.com/iputils/iputils/archive/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

importpkg sys-libs/libcap dev-libs/openssl net-dns/libidn2 dev-libs/icu dev-libs/libgcrypt net-libs/gnutls

domeson

finalize
