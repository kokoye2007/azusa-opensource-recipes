#!/bin/sh
set -e

PKG_CONFIG_VER=0.29.2
BASEDIR=`pwd`
PKG="dev.pkg-config"

source "$BASEDIR/../../common/init.sh"

get https://pkg-config.freedesktop.org/releases/pkg-config-${PKG_CONFIG_VER}.tar.gz

if [ ! -d pkg-config-${PKG_CONFIG_VER} ]; then
	echo "Extracting pkg-config-${PKG_CONFIG_VER} ..."
	tar xf pkg-config-${PKG_CONFIG_VER}.tar.gz
fi

echo "Compiling pkg-config-${PKG_CONFIG_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../pkg-config-${PKG_CONFIG_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.pkg-config.${PKG_CONFIG_VER} \
--includedir=/pkg/main/dev.pkg-config.${PKG_CONFIG_VER}/include --libdir=/pkg/main/libs.pkg-config.${PKG_CONFIG_VER} --datarootdir=/pkg/main/core.pkg-config.${PKG_CONFIG_VER}/share \
--mandir=/pkg/main/doc.pkg-config.${PKG_CONFIG_VER}/man --docdir=/pkg/main/doc.pkg-config.${PKG_CONFIG_VER}/doc \
--enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.pkg-config.${PKG_CONFIG_VER}"
squash "dist/pkg/main/core.pkg-config.${PKG_CONFIG_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
