#!/bin/sh
source "../../common/init.sh"

get https://downloads.asterisk.org/pub/telephony/asterisk/releases/${P}.tar.gz
acheck

cd "${S}"

importpkg sys-apps/util-linux dev-libs/libxml2 dev-libs/icu dev-db/sqlite dev-lang/lua libxcrypt media-libs/speex media-libs/libvorbis sys-libs/libcap net-libs/pjproject net-dns/unbound sys-libs/zlib media-libs/codec2 dev-libs/popt media-libs/alsa-lib media-libs/libsdl dev-libs/openssl dev-db/mariadb

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

export CFLAGS="$CPPFLAGS -pipe"

doconf "${CONFIG[@]}"

make menuselect.makeopts

# some config
# astdb2* tools aren't useful
for foo in astdb2sqlite3 astdb2bdb build_native; do
	./menuselect/menuselect --disable $foo menuselect.makeopts
done
# ensure the following is enabled
for foo in smsq streamplayer aelparse astman chan_mgcp res_pktccops pbx_dundi func_aes chan_iax2 cdr_sqlite3_custom cel_sqlite3_custom codec_codec2 func_curl res_config_curl res_curl res_http_post func_iconv pbx_lua app_mysql cdr_mysql res_config_mysql app_voicemail; do
	./menuselect/menuselect --enable $foo menuselect.makeopts
done

_make_args=(
	"NOISY_BUILD=yes"
	"ASTDBDIR=\$(ASTDATADIR)/astdb"
	"ASTVARRUNDIR=/run/asterisk"
	"ASTCACHEDIR=/var/cache/asterisk"
	"OPTIMIZE="
	"DEBUG="
	"DESTDIR=${D}"
	"CONFIG_SRC=configs/samples"
	"CONFIG_EXTEN=.sample"
	"AST_FORTIFY_SOURCE="
)

make "${_make_args[@]}"
make "${_make_args[@]}" install install-headers install-configs DESTDIR="${D}"

# make asterisk work
ln -snf /pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX ${D}/pkg/main/${PKG}.core.${PVRF}/lib

fixelf
archive
