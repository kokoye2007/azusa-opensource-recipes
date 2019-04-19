#!/bin/sh
set -e

NCURSES_VER=6.1
BASEDIR=`pwd`
PKG="libs.ncurses"

source "$BASEDIR/../../common/init.sh"

get https://invisible-mirror.net/archives/ncurses/ncurses-${NCURSES_VER}.tar.gz

if [ ! -d ncurses-${NCURSES_VER} ]; then
	echo "Extracting ncurses-${NCURSES_VER} ..."
	tar xf ncurses-${NCURSES_VER}.tar.gz

	sed -i '/LIBTOOL_INSTALL/d' ncurses-${NCURSES_VER}/c++/Makefile.in
fi

echo "Compiling ncurses-${NCURSES_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../ncurses-${NCURSES_VER}/configure >configure.log 2>&1 --prefix=/pkg/main/core.ncurses.${NCURSES_VER} --sysconfdir=/etc \
--includedir=/pkg/main/dev.ncurses.${NCURSES_VER}/include --libdir=/pkg/main/libs.ncurses.${NCURSES_VER}/lib --datarootdir=/pkg/main/core.ncurses.${NCURSES_VER}/share \
--mandir=/pkg/main/doc.ncurses.${NCURSES_VER}/man \
--enable-widec --enable-pc-files --with-shared --without-normal --without-debug

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv dist/usr/share/pkgconfig "dist/pkg/main/dev.ncurses.${NCURSES_VER}/"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.ncurses.${NCURSES_VER}"
squash "dist/pkg/main/doc.ncurses.${NCURSES_VER}"
squash "dist/pkg/main/core.ncurses.${NCURSES_VER}"
squash "dist/pkg/main/libs.ncurses.${NCURSES_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
