#!/bin/sh
set -e

FILE_VER=5.36
BASEDIR=`pwd`
source "$BASEDIR/../../common/init.sh"

get ftp://ftp.astron.com/pub/file/file-${FILE_VER}.tar.gz

if [ ! -d file-${FILE_VER} ]; then
	echo "Extracting file-${FILE_VER} ..."
	tar xf file-${FILE_VER}.tar.gz
fi

echo "Compiling file-${FILE_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../file-${FILE_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.file.${FILE_VER} \
--includedir=/pkg/main/dev.file.${FILE_VER}/include --libdir=/pkg/main/libs.file.${FILE_VER} --datarootdir=/pkg/main/core.file.${FILE_VER}/share \
--mandir=/pkg/main/dev.file.${FILE_VER}/share/man --docdir=/pkg/main/dev.file.${FILE_VER}/share/doc/file
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.file.${FILE_VER}"
squash "dist/pkg/main/libs.file.${FILE_VER}"
squash "dist/pkg/main/core.file.${FILE_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
