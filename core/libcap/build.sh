#!/bin/sh
set -e

LIBCAP_VER=2.27
BASEDIR=`pwd`
PKG="core.libcap"

source "$BASEDIR/../../common/init.sh"

get https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-${LIBCAP_VER}.tar.gz

if [ ! -d libcap-${LIBCAP_VER} ]; then
	echo "Extracting libcap-${LIBCAP_VER} ..."
	tar xf libcap-${LIBCAP_VER}.tar.gz
	sed -i '/install.*STALIBNAME/d' libcap-${LIBCAP_VER}/libcap/Makefile
fi

echo "Compiling libcap-${LIBCAP_VER} ..."
cd libcap-${LIBCAP_VER}

# configure & build
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install RAISE_SETFCAP=no prefix="${BASEDIR}/dist/work"

cd ..

mkdir -p "dist/pkg/main/libs.libcap.${LIBCAP_VER}" "dist/pkg/main/dev.libcap.${LIBCAP_VER}" "dist/pkg/main/core.libcap.${LIBCAP_VER}" "dist/pkg/main/doc.libcap.${LIBCAP_VER}"
mv dist/work/sbin "dist/pkg/main/core.libcap.${LIBCAP_VER}"
mv dist/work/include "dist/pkg/main/dev.libcap.${LIBCAP_VER}"
mv dist/work/lib64/pkgconfig "dist/pkg/main/dev.libcap.${LIBCAP_VER}"
mv dist/work/lib64 "dist/pkg/main/libs.libcap.${LIBCAP_VER}"
mv dist/work/share/man "dist/pkg/main/doc.libcap.${LIBCAP_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.libcap.${LIBCAP_VER}"
squash "dist/pkg/main/doc.libcap.${LIBCAP_VER}"
squash "dist/pkg/main/libs.libcap.${LIBCAP_VER}"
squash "dist/pkg/main/core.libcap.${LIBCAP_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
