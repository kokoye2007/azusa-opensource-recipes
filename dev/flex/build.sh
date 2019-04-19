#!/bin/sh
set -e

FLEX_VER=2.6.4
BASEDIR=`pwd`
PKG="dev.flex"

source "$BASEDIR/../../common/init.sh"

get https://github.com/westes/flex/files/981163/flex-${FLEX_VER}.tar.gz

if [ ! -d flex-${FLEX_VER} ]; then
	echo "Extracting flex-${FLEX_VER} ..."
	tar xf flex-${FLEX_VER}.tar.gz

	sed -i "/math.h/a #include <malloc.h>" flex-${FLEX_VER}/src/flexdef.h
fi

echo "Compiling flex-${FLEX_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
HELP2MAN=/bin/true ../flex-${FLEX_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.flex.${FLEX_VER} \
--includedir=/pkg/main/dev.flex.${FLEX_VER}/include --libdir=/pkg/main/libs.flex.${FLEX_VER}/lib --datarootdir=/pkg/main/core.flex.${FLEX_VER} \
--mandir=/pkg/main/doc.flex.${FLEX_VER}/man --docdir=/pkg/main/doc.flex.${FLEX_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv "dist/pkg/main/core.flex.${FLEX_VER}/info" "dist/pkg/main/doc.flex.${FLEX_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.flex.${FLEX_VER}"
squash "dist/pkg/main/dev.flex.${FLEX_VER}"
squash "dist/pkg/main/libs.flex.${FLEX_VER}"
squash "dist/pkg/main/core.flex.${FLEX_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
