#/bin/sh
set -e

ZLIB_VER=1.2.11
ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac

# fetch zlib, compile, build
if [ ! -f zlib-${ZLIB_VER}.tar.gz ]; then
	wget http://zlib.net/zlib-${ZLIB_VER}.tar.gz
fi

if [ ! -d zlib-${ZLIB_VER} ]; then
	echo "Extracting zlib-${ZLIB_VER} ..."
	tar xf zlib-${ZLIB_VER}.tar.gz
fi

echo "Compiling zlib-${ZLIB_VER} ..."
cd zlib-${ZLIB_VER}
make distclean >make_distclean.log 2>&1

# configure & build
./configure >configure.log 2>&1 --prefix=/pkg/by-name/dev.zlib.${ZLIB_VER} --libdir=/pkg/by-name/libs.zlib.${ZLIB_VER}
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
