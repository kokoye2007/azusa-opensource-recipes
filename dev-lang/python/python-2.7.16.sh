#!/bin/sh
source "../../common/init.sh"

get https://www.python.org/ftp/python/${PV}/Python-${PV}.tar.xz

cd "Python-${PV}"

doconf --with-system-expat --with-system-ffi --with-ensurepip=yes

make
make install DESTDIR="${D}"

finalize
