#!/bin/sh
set -e

XZ_VER="5.2.4"
ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`
BASEDIR=`pwd`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac

# fetch xz, compile, build
if [ ! -f xz-${XZ_VER}.tar.bz2 ]; then
	wget https://tukaani.org/xz/xz-${XZ_VER}.tar.bz2
fi

if [ ! -d xz-${XZ_VER} ]; then
	echo "Extracting xz-${XZ_VER} ..."
	tar xf xz-${XZ_VER}.tar.bz2
fi

echo "Compiling xz-${XZ_VER} ..."
cd xz-${XZ_VER}
if [ -f Makefile ]; then
	make distclean >make_distclean.log 2>&1
fi

# configure & build
./configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/by-name/core.xz.${XZ_VER} \
--includedir=/pkg/by-name/dev.xz.${XZ_VER}/include --libdir=/pkg/by-name/libs.xz.${XZ_VER} --datarootdir=/pkg/by-name/core.xz.${XZ_VER}/share \
--mandir=/pkg/by-name/dev.xz.${XZ_VER}/share/man --docdir=/pkg/by-name/dev.xz.${XZ_VER}/share/doc/xz
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files
# dist/pkg/by-name/dev.xz.${XZ_VER}
# dist/pkg/by-name/libs.xz.${XZ_VER}

mksquashfs "dist/pkg/by-name/dev.xz.${XZ_VER}" "dist/dev.xz.${XZ_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/by-name/libs.xz.${XZ_VER}" "dist/libs.xz.${XZ_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096
mksquashfs "dist/pkg/by-name/core.xz.${XZ_VER}" "dist/core.xz.${XZ_VER}.${OS}.${ARCH}.squashfs" -all-root -b 4096

for foo in dist/*.squashfs; do
	php ~/projects/tpkg-tools/src/convert.php "$foo"
done


