#!/bin/sh
set -e

GREP_VER=3.3
BASEDIR=`pwd`
PKG="core.grep"

source "$BASEDIR/../../common/init.sh"

get http://ftp.gnu.org/gnu/grep/grep-${GREP_VER}.tar.xz

if [ ! -d grep-${GREP_VER} ]; then
	echo "Extracting grep-${GREP_VER} ..."
	tar xf grep-${GREP_VER}.tar.xz
fi

echo "Compiling grep-${GREP_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../grep-${GREP_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.grep.${GREP_VER} \
--includedir=/pkg/main/dev.grep.${GREP_VER}/include --libdir=/pkg/main/libs.grep.${GREP_VER}/lib --datarootdir=/pkg/main/core.grep.${GREP_VER} \
--mandir=/pkg/main/doc.grep.${GREP_VER}/man --docdir=/pkg/main/doc.grep.${GREP_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv "dist/pkg/main/core.grep.${GREP_VER}/info" "dist/pkg/main/doc.grep.${GREP_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.grep.${GREP_VER}"
squash "dist/pkg/main/core.grep.${GREP_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
