#!/bin/sh
set -e

SED_VER=4.7
BASEDIR=`pwd`
PKG="core.sed"

source "$BASEDIR/../../common/init.sh"

get http://ftp.gnu.org/gnu/sed/sed-${SED_VER}.tar.xz

if [ ! -d sed-${SED_VER} ]; then
	echo "Extracting sed-${SED_VER} ..."
	tar xf sed-${SED_VER}.tar.xz
fi

echo "Compiling sed-${SED_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../sed-${SED_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.sed.${SED_VER} \
--includedir=/pkg/main/dev.sed.${SED_VER}/include --libdir=/pkg/main/libs.sed.${SED_VER}/lib --datarootdir=/pkg/main/core.sed.${SED_VER} \
--mandir=/pkg/main/doc.sed.${SED_VER}/man --docdir=/pkg/main/doc.sed.${SED_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv "dist/pkg/main/core.sed.${SED_VER}/info" "dist/pkg/main/doc.sed.${SED_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.sed.${SED_VER}"
squash "dist/pkg/main/core.sed.${SED_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
