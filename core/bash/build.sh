#!/bin/sh
set -e

BASH_VER=5.0
BASEDIR=`pwd`
PKG="core.bash"

source "$BASEDIR/../../common/init.sh"

get http://ftp.gnu.org/gnu/bash/bash-${BASH_VER}.tar.gz

if [ ! -d bash-${BASH_VER} ]; then
	echo "Extracting bash-${BASH_VER} ..."
	tar xf bash-${BASH_VER}.tar.gz
fi

echo "Compiling bash-${BASH_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../bash-${BASH_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.bash.${BASH_VER} \
--includedir=/pkg/main/dev.bash.${BASH_VER}/include --libdir=/pkg/main/libs.bash.${BASH_VER}/lib --datarootdir=/pkg/main/core.bash.${BASH_VER} \
--mandir=/pkg/main/doc.bash.${BASH_VER}/man --docdir=/pkg/main/doc.bash.${BASH_VER}/doc \
--without-bash-malloc --with-installed-readline

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mv "dist/pkg/main/libs.bash.${BASH_VER}/lib/pkgconfig" "dist/pkg/main/dev.bash.${BASH_VER}"
mv "dist/pkg/main/core.bash.${BASH_VER}/info" "dist/pkg/main/doc.bash.${BASH_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/doc.bash.${BASH_VER}"
squash "dist/pkg/main/core.bash.${BASH_VER}"
squash "dist/pkg/main/dev.bash.${BASH_VER}"
squash "dist/pkg/main/libs.bash.${BASH_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
