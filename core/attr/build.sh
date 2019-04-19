#!/bin/sh
set -e

ATTR_VER=2.4.48
BASEDIR=`pwd`
PKG="core.attr"

source "$BASEDIR/../../common/init.sh"

get http://download.savannah.nongnu.org/releases/attr/attr-${ATTR_VER}.tar.gz

if [ ! -d attr-${ATTR_VER} ]; then
	echo "Extracting attr-${ATTR_VER} ..."
	tar xf attr-${ATTR_VER}.tar.gz
fi

echo "Compiling attr-${ATTR_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../attr-${ATTR_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.attr.${ATTR_VER} \
--includedir=/pkg/main/dev.attr.${ATTR_VER}/include --libdir=/pkg/main/libs.attr.${ATTR_VER}/lib --datarootdir=/pkg/main/core.attr.${ATTR_VER} \
--mandir=/pkg/main/doc.attr.${ATTR_VER}/man --docdir=/pkg/main/doc.attr.${ATTR_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mkdir "dist/pkg/main/dev.attr.${ATTR_VER}/lib"
mv "dist/pkg/main/libs.attr.${ATTR_VER}/lib"/*.a "dist/pkg/main/dev.attr.${ATTR_VER}/lib"
mv "dist/pkg/main/libs.attr.${ATTR_VER}/lib/pkgconfig" "dist/pkg/main/dev.attr.${ATTR_VER}"
mv "dist/etc" "dist/pkg/main/core.attr.${ATTR_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.attr.${ATTR_VER}"
squash "dist/pkg/main/doc.attr.${ATTR_VER}"
squash "dist/pkg/main/libs.attr.${ATTR_VER}"
squash "dist/pkg/main/core.attr.${ATTR_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
