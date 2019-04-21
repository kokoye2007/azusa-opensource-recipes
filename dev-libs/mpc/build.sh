#!/bin/sh
set -e

MPC_VER=1.1.0
BASEDIR=`pwd`
PKG="libs.mpc"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VER}.tar.gz

if [ ! -d mpc-${MPC_VER} ]; then
	echo "Extracting mpc-${MPC_VER} ..."
	tar xf mpc-${MPC_VER}.tar.gz
fi

echo "Compiling mpc-${MPC_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../mpc-${MPC_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.mpc.${MPC_VER} \
--includedir=/pkg/main/dev.mpc.${MPC_VER}/include --libdir=/pkg/main/libs.mpc.${MPC_VER} --datarootdir=/pkg/main/core.mpc.${MPC_VER}/share \
--mandir=/pkg/main/dev.mpc.${MPC_VER}/share/man --docdir=/pkg/main/dev.mpc.${MPC_VER}/share/doc/mpc \
--disable-static --with-mpfr-include=/pkg/main/dev.mpfr/include/ --with-mpfr-lib=/pkg/main/libs.mpfr/ \
--with-gmp-include=/pkg/main/dev.gmp/include/ --with-gmp-lib=/pkg/main/libs.gmp/

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.mpc.${MPC_VER}"
squash "dist/pkg/main/core.mpc.${MPC_VER}"
squash "dist/pkg/main/libs.mpc.${MPC_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
