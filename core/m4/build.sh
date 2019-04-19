#!/bin/sh
set -e

M4_VER=1.4.18
BASEDIR=`pwd`
PKG="core.m4"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/m4/m4-${M4_VER}.tar.xz

if [ ! -d m4-${M4_VER} ]; then
	echo "Extracting m4-${M4_VER} ..."
	tar xf m4-${M4_VER}.tar.xz
	patch -p0 <m4-1.4.18-glibc-change-work-around.patch
fi

echo "Compiling m4-${M4_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../m4-${M4_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.m4.${M4_VER} \
--includedir=/pkg/main/dev.m4.${M4_VER}/include --libdir=/pkg/main/libs.m4.${M4_VER} --datarootdir=/pkg/main/core.m4.${M4_VER}/share \
--mandir=/pkg/main/dev.m4.${M4_VER}/share/man --docdir=/pkg/main/dev.m4.${M4_VER}/share/doc/m4 \
--with-gnu-ld
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.m4.${M4_VER}"
squash "dist/pkg/main/core.m4.${M4_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
