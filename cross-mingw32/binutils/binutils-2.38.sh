#!/bin/sh
source "../../common/init.sh"

# we force category so this will get binutils from the right path
CATEGORY=sys-devel get https://ftp.gnu.org/gnu/binutils/${P}.tar.xz

CATEGORY=cross-mingw32
acheck

importpkg zlib

# default libpath should include glibc path so gcc can find -lc
export LIB_PATH=/lib:`realpath /pkg/main/sys-libs.glibc.libs/lib64`

cd "${T}"

# make sure -lz works
export LDFLAGS="$(pkg-config zlib --libs-only-L)"

# configure & build
doconf --target=x86_64-pc-mingw32 --program-prefix=x86_64-pc-mingw32- --enable-gold --enable-ld=default --enable-plugins --enable-shared --enable-64-bit-bfd --with-system-zlib

make
make install DESTDIR="${D}"

finalize
