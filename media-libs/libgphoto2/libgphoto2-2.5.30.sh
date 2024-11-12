#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/gphoto/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-devel/libtool

doconf --with-doc-dir="/pkg/main/${PKG}.doc.${PVRF}/doc" --disable-docs --disable-gp2ddb --enable-nls --with-libexif=auto --with-gd --with-jpeg --enable-serial --enable-lockdev --with-libusb=no --with-libusb-1.0=auto --disable-ttylock --with-camlibs=""--with-rpmbuild=/bin/true --with-camlibs=all

make
make install DESTDIR="${D}"

finalize
