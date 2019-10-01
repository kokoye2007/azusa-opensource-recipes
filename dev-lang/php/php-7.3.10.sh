#!/bin/sh
source "../../common/init.sh"

get https://www.php.net/distributions/${P}.tar.xz
acheck

# which PHP SAPIs to be compiled
SAPIS="embed cli cgi fpm apache2 phpdbg"

for sapi in $SAPIS; do
	rm -fr "${T}"
	mkdir -p "${T}"
	cd "${T}"

	CONFIGURE=()

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

	# encoding stuff
	CONFIGURE+=("--with-iconv" "--with-iconv-dir" "--enable-mbstring")
	# libintl (ICU)
	CONFIGURE+=("--enable-intl" "--with-icu-dir=/pkg/main/dev-libs.icu.core")
	# features
	CONFIGURE+=("--enable-calendar" "--enable-exif" "--enable-pcntl" "--enable-bcmath" "--with-gettext" "--with-password-argon2=/pkg/main/app-crypt.argon2.dev")
	# compression
	CONFIGURE+=("--with-zlib" "--with-zlib-dir=/pkg/main/sys-libs.zlib.dev" "--with-bz2=/pkg/main/app-arch.bzip2.dev" "--enable-zip=/pkg/main/dev-libs.libzip.dev")
	# MySQL
	CONFIGURE+=("--with-mysqli=mysqlnd" "--with-pdo-mysql=mysqlnd")
	# GD
	CONFIGURE+=("--with-gd" "--with-jpeg-dir=/pkg/main/media-libs.libjpeg-turbo.dev" "--with-png-dir=/pkg/main/media-libs.libpng.dev" "--with-freetype-dir=/pkg/main/media-libs.freetype.dev")
	# XML
	CONFIGURE+=("--enable-wddx" "--with-xmlrpc" "--with-xsl" "--with-tidy" "--enable-soap")
	# OpenSSL
	CONFIGURE+=("--with-openssl" "--with-mhash" "--with-gmp=/pkg/main/dev-libs.gmp.dev")
	# Network
	CONFIGURE+=("--enable-sockets" "--enable-ftp" "--with-curl=/pkg/main/net-misc.curl.dev" "--with-imap=/pkg/main/net-libs.c-client.dev" "--with-imap-ssl")
	# Basic stuff
	CONFIGURE+=("--with-config-file-path=/etc/php/php-$sapi")

	doconf "${CONFIGURE[@]}"

	make
	make install DESTDIR="${D}"
done

finalize
