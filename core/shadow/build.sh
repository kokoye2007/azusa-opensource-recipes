#!/bin/sh
set -e

SHADOW_VER=4.6
BASEDIR=`pwd`
PKG="core.shadow"

source "$BASEDIR/../../common/init.sh"

get https://github.com/shadow-maint/shadow/releases/download/${SHADOW_VER}/shadow-${SHADOW_VER}.tar.xz

if [ ! -d shadow-${SHADOW_VER} ]; then
	echo "Extracting shadow-${SHADOW_VER} ..."
	tar xf shadow-${SHADOW_VER}.tar.gz
fi

echo "Compiling shadow-${SHADOW_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../shadow-${SHADOW_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.shadow.${SHADOW_VER} \
--includedir=/pkg/main/dev.shadow.${SHADOW_VER}/include --libdir=/pkg/main/libs.shadow.${SHADOW_VER} --datarootdir=/pkg/main/core.shadow.${SHADOW_VER}/share \
--mandir=/pkg/main/dev.shadow.${SHADOW_VER}/share/man --docdir=/pkg/main/dev.shadow.${SHADOW_VER}/share/doc/shadow

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.shadow.${SHADOW_VER}"
squash "dist/pkg/main/core.shadow.${SHADOW_VER}"
squash "dist/pkg/main/libs.shadow.${SHADOW_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
