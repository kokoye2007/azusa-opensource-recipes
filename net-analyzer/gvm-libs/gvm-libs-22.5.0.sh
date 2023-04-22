#!/bin/sh
source "../../common/init.sh"

get https://github.com/greenbone/gvm-libs/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg libpcap net-libs/libnet net-libs/libssh sys-libs/libxcrypt net-nds/openldap dev-libs/paho-mqtt-c zlib net-libs/gnutls dev-libs/hiredis sys-apps/util-linux

docmake

finalize
