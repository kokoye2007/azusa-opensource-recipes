#!/bin/sh
set -e

BINUTILS_VER=2.32
BASEDIR=`pwd`
PKG="core.binutils"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.xz

if [ ! -d binutils-${BINUTILS_VER} ]; then
	echo "Extracting binutils-${BINUTILS_VER} ..."
	tar xf binutils-${BINUTILS_VER}.tar.xz
fi

echo "Compiling binutils-${BINUTILS_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../binutils-${BINUTILS_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.binutils.${BINUTILS_VER} \
--includedir=/pkg/main/dev.binutils.${BINUTILS_VER}/include --libdir=/pkg/main/libs.binutils.${BINUTILS_VER} --datarootdir=/pkg/main/core.binutils.${BINUTILS_VER}/share \
--mandir=/pkg/main/dev.binutils.${BINUTILS_VER}/share/man --docdir=/pkg/main/dev.binutils.${BINUTILS_VER}/share/doc/binutils \
--enable-gold --enable-ld=default --enable-plugins --enable-shared --enable-64-bit-bfd --with-system-zlib
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.binutils.${BINUTILS_VER}"
squash "dist/pkg/main/core.binutils.${BINUTILS_VER}"
squash "dist/pkg/main/libs.binutils.${BINUTILS_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
