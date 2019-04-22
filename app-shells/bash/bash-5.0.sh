#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/bash/${P}.tar.gz

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
doconf --without-bash-malloc --with-installed-readline

make
make install DESTDIR="${D}"

finalize
