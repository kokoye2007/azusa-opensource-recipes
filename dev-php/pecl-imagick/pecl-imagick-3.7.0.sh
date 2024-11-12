#!/bin/sh
source "../../common/init.sh"

get https://pecl.php.net/get/imagick-"${PV}".tgz
acheck

importpkg ImageMagick
# pecl-imagick will look for MagickWand.h into IM_PREFIX/include instead of listening to pkg-config
# let's help
ln -vsnf /pkg/main/media-gfx.imagemagick.dev/include /pkg/main/media-gfx.imagemagick.core/

VERSIONS="8.1.28 8.2.18 8.3.6"
SAPIS="cli cgi fpm embed phpdbg"

cd "${S}" || exit

for VERSION in $VERSIONS; do
	for SAPI in $SAPIS; do
		PHP_PATH="/pkg/main/dev-lang.php.core.${SAPI}.${VERSION}"
		PHP_SUFFIX=""
		if [ "$SAPI" != cli ]; then
			PHP_SUFFIX="-${SAPI}"
		fi
		"${PHP_PATH}"/bin/phpize"${PHP_SUFFIX}"
		./configure --with-php-config="${PHP_PATH}"/bin/php-config"${PHP_SUFFIX}" --with-imagick=/pkg/main/media-gfx.imagemagick.core --disable-static
		make
		make install INSTALL_ROOT=/tmp/x
		DIR="/pkg/main/${PKG}.mod.php-${SAPI}.${VERSION}.${PVRF}"
		mkdir -p "${D}${DIR}"

		if [ -d /tmp/x/pkg/main/dev-lang.php.dev.*/php ]; then
			mv -v /tmp/x/pkg/main/dev-lang.php.dev.*/php "${D}${DIR}"
		fi
		mv -v /tmp/x/pkg/main/dev-lang.php.libs.*/extensions "${D}${DIR}"

		# cleanup
		rm -fr /tmp/x
		"${PHP_PATH}"/bin/phpize"${PHP_SUFFIX}" --clean
	done
done

#make
#make install DESTDIR="${D}"

finalize
