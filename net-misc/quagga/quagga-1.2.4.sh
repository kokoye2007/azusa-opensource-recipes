#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/quagga/${P}.tar.gz
acheck

# small fix
sed -i 's/__packed/__attribute__((__packed__))/' "$S/lib/prefix.h"

cd "${T}"

importpkg ncurses sys-libs/readline
#export CC="gcc $CPPFLAGS"
export CPPFLAGS="${CPPFLAGS} -fcommon"

# configure & build
doconf

make || /bin/bash -i
make install DESTDIR="${D}"

finalize
