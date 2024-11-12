#!/bin/sh
source "../../common/init.sh"

get https://github.com//libusb/libusb/releases/download/v"${PV}"/"${P}".tar.bz2
acheck

importpkg libudev

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
