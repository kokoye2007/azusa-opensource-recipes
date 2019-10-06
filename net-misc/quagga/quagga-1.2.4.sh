#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/quagga/${P}.tar.gz
acheck

cd "${T}"

importpkg ncurses sys-libs/readline
#export CC="gcc $CPPFLAGS"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
