#!/bin/sh

MAN_VERSION=2.8.5
ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac


if [ ! -f man-db-${MAN_VERSION}.tar.xz ]; then
	wget http://download.savannah.nongnu.org/releases/man-db/man-db-${MAN_VERSION}.tar.xz
fi

if [ ! -d man-db-${MAN_VERSION} ]; then
	tar xf man-db-${MAN_VERSION}.tar.xz
fi

echo "Compiling man-db-${MAN_VERSION} ..."
cd man-db-${MAN_VERSION}
if [ -f Makefile ]; then
	make distclean >make_distclean.log 2>&1
fi

# configure & build
./configure >configure.log 2>&1 --prefix=/pkg/main/core.man-db
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR=../dist

cd ..

echo "Building squashfs..."

# build squashfs files
# dist/pkg/by-name/dev.zlib.${ZLIB_VER}
# dist/pkg/by-name/libs.zlib.${ZLIB_VER}

mksquashfs "dist/pkg/by-name/dev.zlib.${ZLIB_VER}" "dist/dev.zlib.${ZLIB_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/by-name/libs.zlib.${ZLIB_VER}" "dist/libs.zlib.${ZLIB_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
