#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz

cd "Python-${PV}"

# ensure python can build its "bits" for the following packages
PKGS="libffi expat ncurses openssl zlib sqlite3 readline"
export CFLAGS="$(pkg-config --cflags $PKGS)"
export LDFLAGS="$(pkg-config --libs-only-L $PKGS)"

doconf --enable-shared --with-system-expat --with-system-ffi --with-ensurepip=install --enable-unicode=ucs4 --with-cxx-main=g++ --enable-optimizations

make
make install DESTDIR="${D}"

# pyconfig.h is installed in the wrong place
mv -v "${D}/pkg/main/${PKG}.core.${PVR}/include/python2.7"/* "${D}/pkg/main/${PKG}.dev.${PVR}/include/python2.7"
rm -fr "${D}/pkg/main/${PKG}.core.${PVR}/include"
ln -snfv "/pkg/main/${PKG}.dev.${PVR}/include" "${D}/pkg/main/${PKG}.core.${PVR}/include"

finalize
