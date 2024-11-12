#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${P}"/latest/"${P}".tar.bz2
acheck

cd "${P}" || exit

sed -i -e '/socket/d' -e '/"streams"/d' tests/tests.lisp
patch -Np1 -i "$FILESDIR/clisp-2.49-readline7_fixes-1.patch"

importpkg dev-libs/libsigsegv ncurses libffi

cd "${T}" || exit

doconflight --srcdir="${CHPATH}/${P}" --with-threads=POSIX_THREADS --with-ffcall --without-dynamic-modules --with-libffcall-prefix=/pkg/main/dev-libs.libffcall.dev --with-module=wildcard --with-module=rawsock --with-module=bindings/glibc --with-module=postgresql --with-module=clx/new-clx --with-module=berkeley-db --with-module=dbus --with-module=fastcgi --with-module=gdbm --with-module=gtk2 --with-module=pcre --with-module=zlib --with-unicode --with-readline 
# --with-libsigsegv-prefix=/pkg/main/dev-libs.libsigsegv.dev

# increase stack size during build
ulimit -s 16384
make -j1
make install-bin DESTDIR="${D}"

finalize
