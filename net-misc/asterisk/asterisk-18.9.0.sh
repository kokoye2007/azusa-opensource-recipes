#!/bin/sh
source "../../common/init.sh"

get https://downloads.asterisk.org/pub/telephony/asterisk/releases/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-apps/util-linux dev-libs/libxml2 dev-libs/icu dev-db/sqlite dev-lang/lua libxcrypt media-libs/speex media-libs/libvorbis sys-libs/libcap net-libs/pjproject net-dns/unbound sys-libs/zlib media-libs/codec2 dev-libs/popt

CONFIG=(
	LUA_VERSION=5
	--with-crypto
	--with-gsm=internal
	--with-popt
	--with-z
	--with-libedit
	--without-jansson-bundled
	--without-pjproject-bundled
	--with-cap
	--with-codec2
	--with-lua
	--with-gmime
	--with-pjproject
	--with-ssl
	--with-unbound
)

doconf "${CONFIG[@]}" || /bin/bash -i

make
make install DESTDIR="${D}"

finalize
