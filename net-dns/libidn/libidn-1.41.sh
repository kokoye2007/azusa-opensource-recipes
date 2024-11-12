#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-csharp

make
make install DESTDIR="${D}"

finalize
