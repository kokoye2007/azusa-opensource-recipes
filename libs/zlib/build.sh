#/bin/sh
set -e

ZLIB_VER=1.2.11
BASEDIR=`pwd`
PKG="libs.zlib"

source "$BASEDIR/../../common/init.sh"

get http://zlib.net/zlib-${ZLIB_VER}.tar.gz

if [ ! -d zlib-${ZLIB_VER} ]; then
	echo "Extracting zlib-${ZLIB_VER} ..."
	tar xf zlib-${ZLIB_VER}.tar.gz
fi

echo "Compiling zlib-${ZLIB_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../zlib-${ZLIB_VER}/configure >configure.log 2>&1 --prefix=/pkg/main/dev.zlib.${ZLIB_VER} --libdir=/pkg/main/libs.zlib.${ZLIB_VER}/lib
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR=../dist

cd ..

mkdir -p "dist/pkg/main/dev.zlib.${ZLIB_VER}/lib"
mv "dist/pkg/main/libs.zlib.${ZLIB_VER}/lib"/*.a "dist/pkg/main/dev.zlib.${ZLIB_VER}/lib"
mv "dist/pkg/main/libs.zlib.${ZLIB_VER}/lib/pkgconfig" "dist/pkg/main/dev.zlib.${ZLIB_VER}/"


echo "Building squashfs..."

squash "dist/pkg/main/dev.zlib.${ZLIB_VER}"
squash "dist/pkg/main/libs.zlib.${ZLIB_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
