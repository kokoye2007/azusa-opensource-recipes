#!/bin/sh
set -e

GCC_VER=8.3.0
BASEDIR=`pwd`
PKG="dev.gcc"

source "$BASEDIR/../../common/init.sh"

get http://mirrors-usa.go-parts.com/gcc/releases/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.xz

if [ ! -d gcc-${GCC_VER} ]; then
	echo "Extracting gcc-${GCC_VER} ..."
	tar xf gcc-${GCC_VER}.tar.xz
fi

echo "Compiling gcc-${GCC_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../gcc-${GCC_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.gcc.${GCC_VER} \
--includedir=/pkg/main/dev.gcc.${GCC_VER}/include --libdir=/pkg/main/libs.gcc.${GCC_VER} --datarootdir=/pkg/main/core.gcc.${GCC_VER}/share \
--mandir=/pkg/main/dev.gcc.${GCC_VER}/share/man --docdir=/pkg/main/dev.gcc.${GCC_VER}/share/doc/gcc \
--enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

# fix some stuff
mv dist/usr/include/* dist/pkg/main/dev.gcc.${GCC_VER}/include/
mv dist/pkg/main/lib* dist/pkg/main/libs.gcc.${GCC_VER}/

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.gcc.${GCC_VER}"
squash "dist/pkg/main/core.gcc.${GCC_VER}"
squash "dist/pkg/main/libs.gcc.${GCC_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
