#!/bin/sh
source "../../common/init.sh"

get http://avahi.org/download/${P}.tar.gz

cd "${P}"
PATCHES=(
	"${FILESDIR}/${P}-qt5.patch"
	"${FILESDIR}/${P}-CVE-2017-6519.patch"
	"${FILESDIR}/${P}-remove-empty-avahi_discover.patch"
	"${FILESDIR}/${P}-python3.patch"
	"${FILESDIR}/${P}-python3-unittest.patch"
	"${FILESDIR}/${P}-python3-gdbm.patch"
)
apatch $PATCHES

acheck

libtoolize --force --install
autoreconf -fi -I /pkg/main/azusa.symlinks.core/share/aclocal/

cd "${T}"
importpkg expat sys-libs/gdbm

export PYTHON=/pkg/main/dev-lang.python.core/bin/python3
doconf --sysconfdir=/etc --localstatedir=/var --disable-qt3 --disable-qt4 --disable-qt5 --disable-gtk --disable-gtk3 --disable-static --disable-mono --disable-monodoc --with-distro=none --with-systemdsystemunitdir=no --enable-gdbm --enable-dbus --disable-python

make
make install DESTDIR="${D}"

finalize
