#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/bash/${P}.tar.gz

echo "Compiling ${P} ..."
cd "${T}"

# force readline to be linkable (and everything, really)
export LIBS="-L/pkg/main/core.symlinks/full/lib$LIB_SUFFIX"

# configure & build
doconf --without-bash-malloc --with-installed-readline

make
make install DESTDIR="${D}"

# add sh symlink
cd "${D}/pkg/main/${PKG}.core.${PVR}/bin"
ln -snf bash sh

finalize
