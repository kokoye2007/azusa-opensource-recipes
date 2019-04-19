#!/bin/sh
set -e

READLINE_VER=8.0
BASEDIR=`pwd`
PKG="libs.readline"

source "$BASEDIR/../../common/init.sh"

get https://ftp.gnu.org/gnu/readline/readline-${READLINE_VER}.tar.gz

if [ ! -d readline-${READLINE_VER} ]; then
	echo "Extracting readline-${READLINE_VER} ..."
	tar xf readline-${READLINE_VER}.tar.gz
fi

echo "Compiling readline-${READLINE_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../readline-${READLINE_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.readline.${READLINE_VER} \
--includedir=/pkg/main/dev.readline.${READLINE_VER}/include --libdir=/pkg/main/libs.readline.${READLINE_VER} --datarootdir=/pkg/main/core.readline.${READLINE_VER}/share \
--mandir=/pkg/main/dev.readline.${READLINE_VER}/share/man --docdir=/pkg/main/dev.readline.${READLINE_VER}/share/doc/readline
make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

# move stuff
mkdir -p "dist/pkg/main/dev.readline.${READLINE_VER}/lib"
mv "dist/pkg/main/libs.readline.${READLINE_VER}"/*.a "dist/pkg/main/libs.readline.${READLINE_VER}/pkgconfig" "dist/pkg/main/dev.readline.${READLINE_VER}/lib"
mv "dist/pkg/main/core.readline.${READLINE_VER}/share/readline" "dist/pkg/main/dev.readline.${READLINE_VER}/share/"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.readline.${READLINE_VER}"
squash "dist/pkg/main/libs.readline.${READLINE_VER}"
squash "dist/pkg/main/core.readline.${READLINE_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
