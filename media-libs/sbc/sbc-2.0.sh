#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/bluetooth/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
