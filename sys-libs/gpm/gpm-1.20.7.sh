#!/bin/sh
source "../../common/init.sh"

get https://www.nico.schottelius.org/software/gpm/archives/${P}.tar.lzma
#get http://anduin.linuxfromscratch.org/BLFS/gpm/${P}.tar.bz2
acheck

cd "${P}"

importpkg ncurses

# gentoo patches
patch -p1 <"$FILESDIR/gpm-1.20.7-sysmacros.patch"
patch -p1 <"$FILESDIR/gpm-1.20.7-glibc-2.26.patch"

# fix ABI values
sed -i -e '/^abi_lev=/s:=.*:=1:' -e '/^abi_age=/s:=.*:=20:' configure.ac.footer
sed -i -e '/ACLOCAL/,$d' autogen.sh

sed -i -e 's:<gpm.h>:"headers/gpm.h":' src/prog/{display-buttons,display-coords,get-versions}.c

# add AC_CONFIG_MACRO_DIRS([m4])
sed -i '1s;^;AC_CONFIG_MACRO_DIRS([m4])\n;' configure.ac.footer

mkdir m4
sh autogen.sh

libtoolize --force --install
autoreconf --force --install -I config

doconf --disable-static --sysconfdir=/etc

make
make install DESTDIR="${D}"

# make symlink
ln -snf libgpm.so.1.20.0 "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/libgpm.so"

ls -laR "${D}"

finalize
