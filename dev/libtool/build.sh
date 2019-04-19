#!/bin/sh
set -e

LIBTOOL_VER=2.4.6
BASEDIR=`pwd`
PKG="core.libtool"

source "$BASEDIR/../../common/init.sh"

get http://ftp.gnu.org/gnu/libtool/libtool-${LIBTOOL_VER}.tar.gz

if [ ! -d libtool-${LIBTOOL_VER} ]; then
	echo "Extracting libtool-${LIBTOOL_VER} ..."
	tar xf libtool-${LIBTOOL_VER}.tar.gz
fi

echo "Compiling libtool-${LIBTOOL_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../libtool-${LIBTOOL_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.libtool.${LIBTOOL_VER} \
--includedir=/pkg/main/dev.libtool.${LIBTOOL_VER}/include --libdir=/pkg/main/libs.libtool.${LIBTOOL_VER}/lib --datarootdir=/pkg/main/core.libtool.${LIBTOOL_VER} \
--mandir=/pkg/main/doc.libtool.${LIBTOOL_VER}/man --docdir=/pkg/main/doc.libtool.${LIBTOOL_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

#mv "dist/pkg/main/libs.libtool.${LIBTOOL_VER}/lib/pkgconfig" "dist/pkg/main/dev.libtool.${LIBTOOL_VER}"
#mv "dist/pkg/main/core.libtool.${LIBTOOL_VER}/info" "dist/pkg/main/doc.libtool.${LIBTOOL_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.libtool.${LIBTOOL_VER}"
squash "dist/pkg/main/core.libtool.${LIBTOOL_VER}"
squash "dist/pkg/main/dev.libtool.${LIBTOOL_VER}"
squash "dist/pkg/main/libs.libtool.${LIBTOOL_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
