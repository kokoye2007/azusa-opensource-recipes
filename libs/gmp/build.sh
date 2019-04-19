#!/bin/sh
set -e

GMP_VER=6.1.2
BASEDIR=`pwd`
PKG="libs.gmp"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VER}.tar.xz

if [ ! -d gmp-${GMP_VER} ]; then
	echo "Extracting gmp-${GMP_VER} ..."
	tar xf gmp-${GMP_VER}.tar.xz
fi

echo "Compiling gmp-${GMP_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../gmp-${GMP_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.gmp.${GMP_VER} \
--includedir=/pkg/main/dev.gmp.${GMP_VER}/include --libdir=/pkg/main/libs.gmp.${GMP_VER} --datarootdir=/pkg/main/core.gmp.${GMP_VER}/share \
--mandir=/pkg/main/dev.gmp.${GMP_VER}/share/man --docdir=/pkg/main/dev.gmp.${GMP_VER}/share/doc/gmp \
--enable-cxx --disable-static --build=x86_64-unknown-linux-gnu
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv dist/pkg/main/core.gmp.${GMP_VER}/include/gmp.h dist/pkg/main/dev.gmp.${GMP_VER}/include/
rmdir dist/pkg/main/core.gmp.${GMP_VER}/include

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.gmp.${GMP_VER}"
squash "dist/pkg/main/core.gmp.${GMP_VER}"
squash "dist/pkg/main/libs.gmp.${GMP_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
