#!/bin/sh
source "../../common/init.sh"

get https://duktape.org/"${P}".tar.xz
acheck

cd "${S}" || exit

# Set install path
sed -i "s#INSTALL_PREFIX = /usr/local#INSTALL_PREFIX = ${D}/pkg/main/${PKG}.core.${PVRF}#" Makefile.sharedlibrary
mv Makefile.sharedlibrary Makefile

make
make install DESTDIR="${D}"

makepkgconfig -lduktape

finalize
