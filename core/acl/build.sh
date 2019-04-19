#!/bin/sh
set -e

ACL_VER=2.2.53
BASEDIR=`pwd`
PKG="core.acl"

source "$BASEDIR/../../common/init.sh"

get http://download.savannah.nongnu.org/releases/acl/acl-${ACL_VER}.tar.gz

if [ ! -d acl-${ACL_VER} ]; then
	echo "Extracting acl-${ACL_VER} ..."
	tar xf acl-${ACL_VER}.tar.gz
fi

echo "Compiling acl-${ACL_VER} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../acl-${ACL_VER}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/core.acl.${ACL_VER} \
--includedir=/pkg/main/dev.acl.${ACL_VER}/include --libdir=/pkg/main/libs.acl.${ACL_VER}/lib --datarootdir=/pkg/main/core.acl.${ACL_VER} \
--mandir=/pkg/main/doc.acl.${ACL_VER}/man --docdir=/pkg/main/doc.acl.${ACL_VER}/doc

make >make.log 2>&1
mkdir -p ../dist
make >make_install.log 2>&1 install DESTDIR="${BASEDIR}/dist"

cd ..

mkdir "dist/pkg/main/dev.acl.${ACL_VER}/lib"
mv "dist/pkg/main/libs.acl.${ACL_VER}/lib"/*.a "dist/pkg/main/dev.acl.${ACL_VER}/lib"
mv "dist/pkg/main/libs.acl.${ACL_VER}/lib/pkgconfig" "dist/pkg/main/dev.acl.${ACL_VER}"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/dev.acl.${ACL_VER}"
squash "dist/pkg/main/doc.acl.${ACL_VER}"
squash "dist/pkg/main/libs.acl.${ACL_VER}"
squash "dist/pkg/main/core.acl.${ACL_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
