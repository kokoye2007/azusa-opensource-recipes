#/bin/sh
source "../../common/init.sh"

get https://www.php.net/distributions/${P}.tar.xz
acheck

cd "${S}"

# which PHP SAPIs to be compiled
SAPIS="cli cgi fpm embed phpdbg"
# apache2: fails because: apxs:Error: Config file /build/dev-lang.php/7.3.10/dist/etc/httpd.conf not found.

# getting readline to work is a bit of a pain...
importpkg sys-libs/ncurses sys-libs/readline sys-libs/libxcrypt

# override pkgconfig for openssl since this version of PHP doesn't like OpenSSL 3
export OPENSSL_CFLAGS="-I$(realpath "/pkg/main/dev-libs.openssl.dev.1/include")"
export OPENSSL_LIBS="-L$(realpath "/pkg/main/dev-libs.openssl.libs.1/lib$LIB_SUFFIX") -lcrypto -lssl"

for sapi in $SAPIS; do
	echo
	echo "*****"
	echo "** Building PHP ${PV} for $sapi"
	echo "*****"
	echo

	rm -fr "${T}"
	mkdir -p "${T}"
	cd "${T}"

	CONFIGURE=("--disable-all" "--disable-static" "--enable-shared" "--enable-re2c-cgoto" "--with-libdir=lib$LIB_SUFFIX")

	case $sapi in
		apache2)
			CONFIGURE+=("--with-apxs2=/pkg/main/www-servers.apache.core/bin/apxs")
			;;
		*)
			CONFIGURE+=("--enable-$sapi")
			;;
	esac

	if [ x"$sapi" != x"cgi" ]; then
		CONFIGURE+=("--disable-cgi")
	fi
	if [ x"$sapi" != x"cli" ]; then
		CONFIGURE+=("--disable-cli")
	fi
	if [ x"$sapi" != x"phpdbg" ]; then
		CONFIGURE+=("--disable-phpdbg")
	fi

	CONFIGURE+=("--with-libxml=shared,/pkg/main/dev-libs.libxml2.dev")
	CONFIGURE+=("--with-password-argon2=/pkg/main/app-crypt.argon2.dev")
	# compression
	CONFIGURE+=("--with-zlib=shared,/pkg/main/sys-libs.zlib.dev")
	CONFIGURE+=("--with-bz2=shared,/pkg/main/app-arch.bzip2.dev")
	#CONFIGURE+=("--enable-zip=/pkg/main/dev-libs.libzip.dev") # TODO configure: error: could not find usable libzip
	CONFIGURE+=("--with-openssl=shared")
	CONFIGURE+=("--with-sqlite3=shared,/pkg/main/dev-db.sqlite.dev")
	CONFIGURE+=("--enable-bcmath=shared")
	CONFIGURE+=("--enable-calendar")
	CONFIGURE+=("--enable-ctype")
	CONFIGURE+=("--with-ffi")
	CONFIGURE+=("--with-curl=shared,/pkg/main/net-misc.curl.dev")
	CONFIGURE+=("--enable-dba=shared" "--with-gdbm=/pkg/main/sys-libs.gdbm.dev") # TODO implement more dba libs
	CONFIGURE+=("--enable-dom=shared")
	CONFIGURE+=("--with-enchant=shared,/pkg/main/app-text.enchant.dev")
	CONFIGURE+=("--enable-exif=shared")
	CONFIGURE+=("--enable-fileinfo=shared")
	CONFIGURE+=("--enable-filter")
	CONFIGURE+=("--enable-ftp=shared")
	CONFIGURE+=("--enable-gd=shared" "--enable-gd-jis-conv")
	CONFIGURE+=("--with-gettext=shared,/pkg/main/sys-libs.glibc.dev")
	CONFIGURE+=("--with-gmp=shared,/pkg/main/dev-libs.gmp.dev")
	CONFIGURE+=("--with-mhash")
	CONFIGURE+=("--with-iconv")
	#CONFIGURE+=("--with-imap=shared,/pkg/main/net-libs.c-client.dev" "--with-imap-ssl")
	CONFIGURE+=("--enable-intl=shared,/pkg/main/dev-libs.icu.core")
	CONFIGURE+=("--enable-mbstring")
	CONFIGURE+=("--with-mysqli=shared,mysqlnd")
	CONFIGURE+=("--enable-opcache" "--enable-huge-code-pages")
	CONFIGURE+=("--enable-pcntl=shared")
	CONFIGURE+=("--enable-pdo=shared" "--with-pdo-mysql=shared,mysqlnd" "--with-pdo-pgsql=shared,/pkg/main/dev-db.postgresql.dev" "--with-pdo-sqlite=shared,/pkg/main/dev-db.sqlite.dev")
	CONFIGURE+=("--with-pgsql=shared,/pkg/main/dev-db.postgresql.dev")
	CONFIGURE+=("--enable-phar")
	CONFIGURE+=("--enable-posix=shared")
	CONFIGURE+=("--enable-session")
	CONFIGURE+=("--enable-shmop=shared")
	CONFIGURE+=("--enable-simplexml")
	CONFIGURE+=("--enable-soap=shared")
	CONFIGURE+=("--enable-sockets=shared")
	CONFIGURE+=("--enable-sysvmsg=shared" "--enable-sysvsem=shared" "--enable-sysvshm=shared")
	CONFIGURE+=("--with-tidy=shared,/pkg/main/app-text.tidy-html5.dev")
	CONFIGURE+=("--enable-tokenizer")
	CONFIGURE+=("--enable-xml=shared")
	CONFIGURE+=("--enable-xmlreader=shared")
	CONFIGURE+=("--enable-xmlwriter=shared")
	CONFIGURE+=("--with-xsl=shared,/pkg/main/dev-libs.libxslt.dev")
	CONFIGURE+=("--enable-mysqlnd")

	# cgi/cli: readline/libedit support
	case $sapi in
		cli|cgi)
			CONFIGURE+=("--without-pear")
			CONFIGURE+=("--with-readline=/pkg/main/sys-libs.readline.dev")
			export LIBS="-ltinfo" # link php against libtinfo so ncurses/readline works
			;;
		*)
			CONFIGURE+=("--without-pear")
			export LIBS=""
			;;
	esac

	CONFIGURE+=("--with-config-file-path=/etc/php/php-$sapi")

	callconf --prefix="/pkg/main/${PKG}.core.$sapi.${PVRF}" --libdir="/pkg/main/${PKG}.libs.$sapi.${PVRF}" --includedir="/pkg/main/${PKG}.dev.$sapi.${PVRF}" "${CONFIGURE[@]}"

	# replace libtool with system's (add --tag=CXX)
	echo "#!/bin/sh" >libtool
	echo "exec /bin/libtool --tag=CXX \"\$@\"">>libtool

	make -j"$NPROC"
	make install INSTALL_ROOT="${D}"

	# move phpize and php-config /pkg/main/dev-lang.php.core.embed.7.3.10/bin/ if sapi isn't "cli"
	if [ x"$sapi" != x"cli" ]; then
		cd "${D}/pkg/main/${PKG}.core.$sapi.${PVRF}/bin"
		mv phpize "phpize-$sapi"
		mv php-config "php-config-$sapi"
		if [ -f phpdbg ]; then
			mv phpdbg "phpdbg-$sapi"
		fi
	fi
done

fixelf
archive
