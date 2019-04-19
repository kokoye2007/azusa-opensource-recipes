#!/bin/sh
set -e

BC_VER=1.07
BASEDIR=`pwd`
PKG="core.bc"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/bc/bc-${BC_VER}.tar.gz

if [ ! -d bc-${BC_VER} ]; then
	echo "Extracting bc-${BC_VER} ..."
	tar xf bc-${BC_VER}.tar.gz
fi

echo "Compiling bc-${BC_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../bc-${BC_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.bc.${BC_VER} \
--includedir=/pkg/main/dev.bc.${BC_VER}/include --libdir=/pkg/main/libs.bc.${BC_VER} --datarootdir=/pkg/main/core.bc.${BC_VER}/share \
--mandir=/pkg/main/core.bc.${BC_VER}/share/man --docdir=/pkg/main/dev.bc.${BC_VER}/share/doc/bc \
--with-gnu-ld
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/core.bc.${BC_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
