#!/bin/sh
source "../../common/init.sh"

get https://nmap.org/dist/${P}.tgz
acheck

cd "${S}"

doconf \
	--with-openssl=/pkg/main/dev-libs.openssl.dev \
	--with-libpcap=/pkg/main/net-libs.libpcap.dev \
	--with-libpcre=/pkg/main/dev-libs.libpcre2.dev \
	--with-libz=/pkg/main/sys-libs.zlib.dev \
	--with-libssh2=/pkg/main/net-libs.libssh2.dev \
	--with-libdnet=/pkg/main/dev-libs.libdnet.dev \
	--with-liblua=/pkg/main/dev-lang.lua.dev \
	--with-liblinear=/pkg/main/dev-libs.liblinear.dev

make
make install DESTDIR="${D}"

finalize
