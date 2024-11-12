#!/bin/sh
source "../../common/init.sh"

get http://invisible-mirror.net/archives/"${PN}"/"${P}".tgz

cd "${P}" || exit

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap
printf '\tkbs=\\177,\n' >> terminfo

cd "${T}" || exit

importpkg ncurses

TERMINFO="/pkg/main/${PKG}.libs.${PVRF}/terminfo" doconf213 --with-app-defaults=/etc/X11/app-defaults

make
make install DESTDIR="${D}"
make install-ti DESTDIR="${D}"

finalize
