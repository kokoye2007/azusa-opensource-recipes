#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.xz
acheck

cd "${P}"

# fix compile
#sed -i -e '/^GC_is_heap_ptr/s/void/const void/' 'libguile/pairs.h' 
CPPFLAGS="-DHAVE_GC_IS_HEAP_PTR -DHAVE_GC_MOVE_DISAPPEARING_LINK"

cd "${T}"

importpkg sys-devel/libtool dev-libs/gmp dev-libs/libunistring dev-libs/libatomic_ops

doconf --disable-rpath --disable-error-on-warning --disable-static --enable-posix --with-threads --enable-networking --enable-regex

make
make install DESTDIR="${D}"

finalize
