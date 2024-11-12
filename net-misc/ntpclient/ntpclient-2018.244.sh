#!/bin/sh
source "../../common/init.sh"

get https://github.com/troglobit/sntpd/releases/download/"${PV/./_}"/"${P/./_}".tar.xz
acheck

cd "${P/./_}" || exit

apatch "${FILESDIR}/ntpclient-2018.244-linux-headers-5.2.patch"

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
