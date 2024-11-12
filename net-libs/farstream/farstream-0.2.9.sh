#!/bin/sh
source "../../common/init.sh"

get https://freedesktop.org/software/farstream/releases/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
