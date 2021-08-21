#!/bin/sh
source "../../common/init.sh"

get https://downloads.isc.org/isc/bind9/${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib sys-libs/libcap sys-libs/ncurses sys-libs/readline

CONFIGURE=(
	--sysconfdir=/etc
	--localstatedir=/var
	--with-libtool
	--disable-static
	--with-openssl=/pkg/main/dev-libs.openssl.dev
	--with-lmdb=/pkg/main/dev-db.lmdb.dev
	--with-libxml2
	--with-json-c
	--with-zlib
	--with-readline="$(pkg-config --libs readline ncurses)"
	--with-protobuf-c=/pkg/main/dev-libs.protobuf-c.dev
	--with-libfstrm=/pkg/main/dev-libs.fstrm.dev
	--with-libidn2=/pkg/main/net-dns.libidn2.dev
	--with-dlz-postgres=/pkg/main/dev-db.postgresql.dev
	--with-dlz-mysql=/pkg/main/dev-db.mariadb.dev
	--with-dlz-bdb=/pkg/main/sys-libs.db.dev
	--with-dlz-filesystem=yes
)

# bind seems to ignore CPPFLAGS
export CFLAGS="${CPPFLAGS} -O2"

doconf "${CONFIGURE[@]}"

make
make install DESTDIR="${D}"

finalize
