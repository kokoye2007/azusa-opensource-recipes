#!/bin/sh
set -e

GLIBC_VER=2.29
BASEDIR=`pwd`
source "$BASEDIR/../../common/init.sh"

# fetch xz, compile, build
if [ ! -f glibc-${GLIBC_VER}.tar.xz ]; then
	wget http://ftp.jaist.ac.jp/pub/GNU/libc/glibc-${GLIBC_VER}.tar.xz
fi

if [ ! -d glibc-${GLIBC_VER} ]; then
	echo "Extracting glibc-${GLIBC_VER} ..."
	tar xf glibc-${GLIBC_VER}.tar.xz
fi

echo "Compiling glibc-${GLIBC_VER} ..."
#if [ -d work ]; then
#	rm -fr work
#fi
mkdir work
cd work

# configure & build
../glibc-${GLIBC_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.glibc.${GLIBC_VER} \
--includedir=/pkg/main/dev.glibc.${GLIBC_VER}/include --libdir=/pkg/main/libs.glibc.${GLIBC_VER} --datarootdir=/pkg/main/core.glibc.${GLIBC_VER}/share \
--mandir=/pkg/main/dev.glibc.${GLIBC_VER}/share/man --docdir=/pkg/main/dev.glibc.${GLIBC_VER}/share/doc/glibc
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

# move some stuff
mv dist/etc "dist/pkg/main/core.glibc.${GLIBC_VER}"
mv dist/sbin/* "dist/pkg/main/core.glibc.${GLIBC_VER}/sbin"
mv dist/lib*/* "dist/pkg/main/libs.glibc.${GLIBC_VER}"
mv dist/var "dist/pkg/main/core.glibc.${GLIBC_VER}"
rmdir dist/sbin dist/lib*

echo "Building squashfs..."

# build squashfs files

mksquashfs "dist/pkg/main/dev.glibc.${GLIBC_VER}" "dist/dev.glibc.${GLIBC_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/main/libs.glibc.${GLIBC_VER}" "dist/libs.glibc.${GLIBC_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/main/core.glibc.${GLIBC_VER}" "dist/core.glibc.${GLIBC_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
