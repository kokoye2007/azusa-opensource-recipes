#!/bin/sh
source "../../common/init.sh"

get https://downloads.xiph.org/releases/opus/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
