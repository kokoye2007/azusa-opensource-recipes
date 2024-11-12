#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/utils/usb/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
