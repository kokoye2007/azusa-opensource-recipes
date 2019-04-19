#!/bin/sh
set -e

PSMISC_VER=23.2
BASEDIR=`pwd`
PKG="core.psmisc"

source "$BASEDIR/../../common/init.sh"

get https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.2.tar.xz

if [ ! -d psmisc-${PSMISC_VER} ]; then
	echo "Extracting psmisc-${PSMISC_VER} ..."
	tar xf psmisc-${PSMISC_VER}.tar.xz
fi

echo "Compiling psmisc-${PSMISC_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../psmisc-${PSMISC_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.psmisc.${PSMISC_VER} \
--includedir=/pkg/main/dev.psmisc.${PSMISC_VER}/include --libdir=/pkg/main/libs.psmisc.${PSMISC_VER}/lib --datarootdir=/pkg/main/core.psmisc.${PSMISC_VER} \
--mandir=/pkg/main/doc.psmisc.${PSMISC_VER}/man --docdir=/pkg/main/doc.psmisc.${PSMISC_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.psmisc.${PSMISC_VER}"
squash "dist/pkg/main/core.psmisc.${PSMISC_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
