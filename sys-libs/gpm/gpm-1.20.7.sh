#!/bin/sh
source "../../common/init.sh"

get https://www.nico.schottelius.org/software/gpm/archives/${P}.tar.lzma

cd "${P}"

# gentoo patches
patch -p1 <"$FILESDIR/gpm-1.20.7-sysmacros.patch"
patch -p1 <"$FILESDIR/gpm-1.20.7-glibc-2.26.patch"

# fix ABI values
sed -i \
	-e '/^abi_lev=/s:=.*:=1:' \
	-e '/^abi_age=/s:=.*:=20:' \
	configure.ac.footer || die

sed -i -e '/ACLOCAL/,$d' autogen.sh
sh autogen.sh

aclocal-1.16
libtoolize --install
autoheader
autoconf

doconf

make
make install DESTDIR="${D}"

finalize
