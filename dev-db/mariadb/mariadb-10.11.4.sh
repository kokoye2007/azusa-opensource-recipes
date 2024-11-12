#!/bin/sh
source "../../common/init.sh"

get https://downloads.mariadb.org/interstitial/"${P}"/source/"${P}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/mariadb-10.6.12-gcc-13.patch"

cd "${T}" || exit

importpkg libpcre2-8 app-arch/lz4 dev-libs/lzo app-arch/snappy sys-libs/ncurses dev-libs/icu dev-libs/boost libcurl zlib app-arch/bzip2 app-arch/xz dev-libs/libfmt dev-util/systemtap dev-libs/judy app-arch/zstd dev-libs/rocksdb

# mariadb won't honor CPPFLAGS
export CFLAGS="${CPPFLAGS} -O2"
export CXXFLAGS="${CPPFLAGS} -O2"

# disable jemalloc because mariadb is unable to use pkgconfig to locate it

# we will have to customize a lot of stuff for mariadb for it to be clean ... ...... :(

CMAKEOPTS=(
	-DWITH_JEMALLOC=YES
	-DMYSQL_DATADIR=/var/lib/mysql
	-DSYSCONFDIR=/etc/mysql
	-DINSTALL_BINDIR=bin
	-DINSTALL_DOCDIR=/pkg/main/${PKG}.core.${PVRF}/doc/
	-DINSTALL_SBINDIR=sbin
	-DWITH_COMMENT="Azusa"
	-DWITH_UNIT_TESTS=OFF
	-DWITH_LIBEDIT=0
	-DWITH_ZLIB=system
	-DWITHOUT_LIBWRAP=1
	-DENABLED_LOCAL_INFILE=1
	-DMYSQL_UNIX_ADDR="/run/mysqld/mysqld.sock"
	-DINSTALL_UNIX_ADDRDIR="/run/mysqld/mysqld.sock"
	-DWITH_DEFAULT_COMPILER_OPTIONS=0
	-DWITH_DEFAULT_FEATURE_SET=0
	-DINSTALL_SYSTEMD_UNITDIR=OFF
	-DPKG_CONFIG_EXECUTABLE=/usr/bin/pkg-config
	-DCONC_WITH_EXTERNAL_ZLIB=YES
	-DWITH_EXTERNAL_ZLIB=YES
	-DSUFFIX_INSTALL_DIR=""
	-DWITH_UNITTEST=OFF
	-DWITHOUT_CLIENTLIBS=YES
	-DCLIENT_PLUGIN_DIALOG=OFF
	-DCLIENT_PLUGIN_CLIENT_ED25519=DYNAMIC
	-DCLIENT_PLUGIN_MYSQL_CLEAR_PASSWORD=STATIC
	-DCLIENT_PLUGIN_CACHING_SHA2_PASSWORD=DYNAMIC
	-DWITH_SSL=bundled # somehow Cannot find appropriate system libraries for SSL. but found version "3.0.1"
	-DCLIENT_PLUGIN_SHA256_PASSWORD=STATIC
	-DWITH_PCRE=system
	-DPLUGIN_AUTH_PAM=NO
	-DPLUGIN_CASSANDRA=NO
	-DCONNECT_WITH_MYSQL=1
	-DCONNECT_WITH_LIBXML2=1
	-DCONNECT_WITH_MONGO=OFF
	-DWITH_INNODB_LZ4=ON
	-DWITH_INNODB_LZO=ON
	-DWITH_INNODB_SNAPPY=ON
	-DWITH_MARIABACKUP=ON
	-DWITH_LIBARCHIVE=ON
	-DPLUGIN_ROCKSDB=DYNAMIC
	-DWITH_SYSTEMD=no
	-DEXTRA_CHARSETS=all
	-DDEFAULT_CHARSET=utf8
	-DDEFAULT_COLLATION=utf8_general_ci
	-DMYSQL_USER=mysql
	-DDISABLE_SHARED=NO
	-DWITH_PROFILING=1
	-DWITH_PIC=1
	-DWITH_ARCHIVE_STORAGE_ENGINE=1
	-DWITH_BLACKHOLE_STORAGE_ENGINE=1
	-DWITH_CSV_STORAGE_ENGINE=1
	-DWITH_HEAP_STORAGE_ENGINE=1
	-DWITH_INNOBASE_STORAGE_ENGINE=1
	-DWITH_MYISAMMRG_STORAGE_ENGINE=1
	-DWITH_MYISAM_STORAGE_ENGINE=1
	-DWITH_PARTITION_STORAGE_ENGINE=1
)

# -DBUILD_CONFIG=mysql_release
docmake "${CMAKEOPTS[@]}"

finalize
