#!/bin/sh
set -e

XZ_VER="5.2.4"
BASEDIR=`pwd`
PKG="libs.zlib"

source "$BASEDIR/../../common/init.sh"

get https://tukaani.org/xz/xz-${XZ_VER}.tar.bz2

if [ ! -d xz-${XZ_VER} ]; then
	echo "Extracting xz-${XZ_VER} ..."
	tar xf xz-${XZ_VER}.tar.bz2
fi

echo "Compiling xz-${XZ_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../xz-${XZ_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.xz.${XZ_VER} \
--includedir=/pkg/main/dev.xz.${XZ_VER}/include --libdir=/pkg/main/libs.xz.${XZ_VER}/lib --datarootdir=/pkg/main/core.xz.${XZ_VER}/share \
--mandir=/pkg/main/doc.xz.${XZ_VER}/man --docdir=/pkg/main/doc.xz.${XZ_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mkdir -p "dist/pkg/main/dev.xz.${XZ_VER}/lib"
mv "dist/pkg/main/libs.xz.${XZ_VER}/lib"/*.a "dist/pkg/main/dev.xz.${XZ_VER}/lib"
mv "dist/pkg/main/libs.xz.${XZ_VER}/lib/pkgconfig" "dist/pkg/main/dev.xz.${XZ_VER}/"

echo "Building squashfs..."

# build squashfs files
# dist/pkg/main/dev.xz.${XZ_VER}
# dist/pkg/main/libs.xz.${XZ_VER}

squash "dist/pkg/main/dev.xz.${XZ_VER}"
squash "dist/pkg/main/doc.xz.${XZ_VER}"
squash "dist/pkg/main/libs.xz.${XZ_VER}"
squash "dist/pkg/main/core.xz.${XZ_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
