#!/bin/sh
set -e

MPFR_VER=4.0.2
BASEDIR=`pwd`
PKG="libs.mpfr"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VER}.tar.xz

if [ ! -d mpfr-${MPFR_VER} ]; then
	echo "Extracting mpfr-${MPFR_VER} ..."
	tar xf mpfr-${MPFR_VER}.tar.xz
fi

echo "Compiling mpfr-${MPFR_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../mpfr-${MPFR_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.mpfr.${MPFR_VER} \
--includedir=/pkg/main/dev.mpfr.${MPFR_VER}/include --libdir=/pkg/main/libs.mpfr.${MPFR_VER} --datarootdir=/pkg/main/core.mpfr.${MPFR_VER}/share \
--mandir=/pkg/main/dev.mpfr.${MPFR_VER}/share/man --docdir=/pkg/main/dev.mpfr.${MPFR_VER}/share/doc/mpfr \
--disable-static --enable-thread-safe
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv dist/pkg/main/libs.mpfr.${MPFR_VER}/pkgconfig dist/pkg/main/dev.mpfr.${MPFR_VER}/

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.mpfr.${MPFR_VER}"
squash "dist/pkg/main/core.mpfr.${MPFR_VER}"
squash "dist/pkg/main/libs.mpfr.${MPFR_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
