#!/bin/sh
set -e

PAM_VER=1.3.1
BASEDIR=`pwd`
PKG="core.pam"

source "$BASEDIR/../../common/init.sh"

get https://github.com/linux-pam/linux-pam/releases/download/v${PAM_VER}/Linux-PAM-${PAM_VER}.tar.xz

exit

if [ ! -d Linux-PAM-${PAM_VER} ]; then
	echo "Extracting pam-${PAM_VER} ..."
	tar xf Linux-PAM-${PAM_VER}.tar.gz
fi

echo "Compiling Linux-PAM-${PAM_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../Linux-PAM-${PAM_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.pam.${PAM_VER} \
--includedir=/pkg/main/dev.pam.${PAM_VER}/include --libdir=/pkg/main/libs.pam.${PAM_VER} --datarootdir=/pkg/main/core.pam.${PAM_VER}/share \
--mandir=/pkg/main/dev.pam.${PAM_VER}/share/man --docdir=/pkg/main/dev.pam.${PAM_VER}/share/doc/pam

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.pam.${PAM_VER}"
squash "dist/pkg/main/core.pam.${PAM_VER}"
squash "dist/pkg/main/libs.pam.${PAM_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
