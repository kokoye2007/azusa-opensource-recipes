#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.alsa-project.org/pub/lib/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
