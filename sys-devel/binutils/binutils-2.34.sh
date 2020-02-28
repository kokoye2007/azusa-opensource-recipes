#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/binutils/${P}.tar.xz
acheck

importpkg zlib

# default libpath should include glibc path so gcc can find -lc
export LIB_PATH=/lib:`realpath /pkg/main/sys-libs.glibc.libs/lib$LIB_SUFFIX`

cd "${T}"

# make sure -lz works
export LDFLAGS="$(pkg-config zlib --libs-only-L)"

# configure & build
doconf --enable-gold --enable-ld=default --enable-plugins --enable-shared --enable-64-bit-bfd --with-system-zlib

make
make install DESTDIR="${D}"

finalize
