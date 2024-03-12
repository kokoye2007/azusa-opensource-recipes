#!/bin/sh
source "../../common/init.sh"

get https://downloads.isc.org/isc/bind9/${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib sys-libs/libcap sys-libs/ncurses sys-libs/readline

CONFIGURE=(
	--sysconfdir=/etc
	--localstatedir=/var
	--with-openssl=/pkg/main/dev-libs.openssl.dev
	--with-lmdb=/pkg/main/dev-db.lmdb.dev
	--with-libxml2
	--with-json-c
	--with-zlib
	--with-readline="readline"
	--with-libidn2=/pkg/main/net-dns.libidn2.dev
)

# bind seems to ignore CPPFLAGS
export CFLAGS="${CPPFLAGS} -O2"

doconf "${CONFIGURE[@]}"

make
make install DESTDIR="${D}"

finalize
