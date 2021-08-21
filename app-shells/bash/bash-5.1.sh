#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/bash/${P}.tar.gz
acheck

echo "Compiling ${P} ..."
cd "${T}"

importpkg readline

# configure & build
doconf --without-bash-malloc --with-installed-readline

make
make install DESTDIR="${D}"

# add sh symlink
cd "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
ln -snf bash sh

finalize
