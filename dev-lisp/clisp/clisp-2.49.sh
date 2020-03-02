#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${P}/latest/${P}.tar.bz2
acheck

cd "${P}"

sed -i -e '/socket/d' -e '/"streams"/d' tests/tests.lisp
patch -Np1 -i "$FILESDIR/clisp-2.49-readline7_fixes-1.patch"
aautoreconf

importpkg dev-libs/libsigsegv ncurses libffi

cd "${T}"

doconflight --srcdir="${CHPATH}/${P}" --with-libsigsegv-prefix=/pkg/main/dev-libs.libsigsegv.dev --with-libffcall-prefix=/pkg/main/dev-libs.libffcall.dev

# increase stack size during build
ulimit -s 16384
make -j1
make install DESTDIR="${D}"

finalize
