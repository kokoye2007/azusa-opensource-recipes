#!/bin/sh
source "../../common/init.sh"

get https://pcsclite.apdu.fr/files/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf --disable-maintainer-mode --enable-ipcdir=/run/pcscd --with-systemdsystemunitdir= --enable-documentation --disable-libsystemd --enable-libudev --disable-libusb --enable-polkit
# --enable-usbdropdir="${EPREFIX}/usr/$(get_libdir)/readers/usb" ?

make
make install DESTDIR="${D}"

finalize
