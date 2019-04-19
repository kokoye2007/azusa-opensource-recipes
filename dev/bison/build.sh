#!/bin/sh
set -e

BISON_VER=3.3.2
BASEDIR=`pwd`
PKG="dev.bison"

source "$BASEDIR/../../common/init.sh"

get http://ftp.gnu.org/gnu/bison/bison-${BISON_VER}.tar.xz

if [ ! -d bison-${BISON_VER} ]; then
	echo "Extracting bison-${BISON_VER} ..."
	tar xf bison-${BISON_VER}.tar.xz
fi

echo "Compiling bison-${BISON_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../bison-${BISON_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.bison.${BISON_VER} \
--includedir=/pkg/main/dev.bison.${BISON_VER}/include --libdir=/pkg/main/libs.bison.${BISON_VER}/lib --datarootdir=/pkg/main/core.bison.${BISON_VER} \
--mandir=/pkg/main/doc.bison.${BISON_VER}/man --docdir=/pkg/main/doc.bison.${BISON_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.bison.${BISON_VER}"
squash "dist/pkg/main/libs.bison.${BISON_VER}"
squash "dist/pkg/main/core.bison.${BISON_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
