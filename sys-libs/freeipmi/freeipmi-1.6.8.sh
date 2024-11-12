#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.gz
acheck

importpkg libgcrypt

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
