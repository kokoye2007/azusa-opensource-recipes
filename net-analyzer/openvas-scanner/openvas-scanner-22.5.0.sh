#!/bin/sh
source "../../common/init.sh"

get https://github.com/greenbone/openvas-scanner/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg libpcap dev-libs/libgcrypt app-crypt/gpgme dev-libs/paho-mqtt-c net-libs/gnutls dev-libs/libgpg-error app-crypt/libmd

docmake

finalize
