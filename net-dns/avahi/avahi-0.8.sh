#!/bin/sh
source "../../common/init.sh"

get http://avahi.org/download/"${P}".tar.gz
acheck

cd "${T}" || exit
importpkg expat sys-libs/gdbm dev-libs/libdaemon

export PYTHON=/pkg/main/dev-lang.python.core/bin/python3
doconf --sysconfdir=/etc --localstatedir=/var --disable-qt3 --disable-qt4 --disable-qt5 --disable-gtk --disable-gtk3 --disable-static --disable-mono --disable-monodoc --with-distro=none --with-systemdsystemunitdir=no --enable-gdbm --enable-dbus --disable-python

make
make install DESTDIR="${D}"

finalize
