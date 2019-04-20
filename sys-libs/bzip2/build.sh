#/bin/sh
set -e

BZIP2_VER=1.0.6
BASEDIR=`pwd`
PKG="sys-libs.bzip2"

source "$BASEDIR/../../common/init.sh"

get https://sourceware.org/pub/bzip2/bzip2-${BZIP2_VER}.tar.gz

if [ ! -d bzip2-${BZIP2_VER} ]; then
	echo "Extracting bzip2-${BZIP2_VER} ..."
	tar xf bzip2-${BZIP2_VER}.tar.gz
fi

echo "Compiling bzip2-${BZIP2_VER} ..."
cd bzip2-${BZIP2_VER}
make distclean >make_distclean.log 2>&1

# relative symlinks
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# configure & build
make >make.log 2>&1 -f Makefile-libbz2_so
make >>make.log 2>&1 clean
make >>make.log 2>&1

# install
mkdir -p ../dist/work
make >make_install.log 2>&1 install PREFIX=../dist/work

mkdir -p ../dist/pkg/main/${PKG}.{libs,core,dev,doc}.${BZIP2_VER}

# shared libs
mkdir ../dist/pkg/main/${PKG}.libs.${BZIP2_VER}/lib
cp -a libbz2.so* ../dist/pkg/main/${PKG}.libs.${BZIP2_VER}/lib

# copy stuff
mv ../dist/work/bin ../dist/pkg/main/${PKG}.core.${BZIP2_VER}/
mv ../dist/work/man ../dist/pkg/main/${PKG}.doc.${BZIP2_VER}/
mv ../dist/work/include ../dist/pkg/main/${PKG}.dev.${BZIP2_VER}/

cd ..


echo "Building squashfs..."

squash "dist/pkg/main/${PKG}.core.${BZIP2_VER}"
squash "dist/pkg/main/${PKG}.libs.${BZIP2_VER}"
squash "dist/pkg/main/${PKG}.dev.${BZIP2_VER}"
squash "dist/pkg/main/${PKG}.doc.${BZIP2_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
