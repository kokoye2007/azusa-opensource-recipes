#!/bin/sh
set -e

GDBM_VER=1.18.1
BASEDIR=`pwd`
PKG="sys-libs.gdbm"

source "$BASEDIR/../../common/init.sh"

get ftp://ftp.gnu.org/gnu/gdbm/gdbm-${GDBM_VER}.tar.gz

if [ ! -d gdbm-${GDBM_VER} ]; then
	echo "Extracting gdbm-${GDBM_VER} ..."
	tar xf gdbm-${GDBM_VER}.tar.gz
fi

echo "Compiling gdbm-${GDBM_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../gdbm-${GDBM_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.gdbm.${GDBM_VER} \
--includedir=/pkg/main/dev.gdbm.${GDBM_VER}/include --libdir=/pkg/main/libs.gdbm.${GDBM_VER}/lib --datarootdir=/pkg/main/core.gdbm.${GDBM_VER} \
--mandir=/pkg/main/doc.gdbm.${GDBM_VER}/man --docdir=/pkg/main/doc.gdbm.${GDBM_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

mkdir "dist/pkg/main/dev.gdbm.${GDBM_VER}/lib"
mv "dist/pkg/main/libs.gdbm.${GDBM_VER}/lib"/*.a "dist/pkg/main/dev.gdbm.${GDBM_VER}/lib"
mv "dist/pkg/main/core.gdbm.${GDBM_VER}/info" "dist/pkg/main/doc.gdbm.${GDBM_VER}"

# build squashfs files

squash "dist/pkg/main/doc.gdbm.${GDBM_VER}"
squash "dist/pkg/main/dev.gdbm.${GDBM_VER}"
squash "dist/pkg/main/libs.gdbm.${GDBM_VER}"
squash "dist/pkg/main/core.gdbm.${GDBM_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
