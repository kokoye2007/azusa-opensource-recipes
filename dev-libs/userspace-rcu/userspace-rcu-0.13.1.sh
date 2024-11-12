#!/bin/sh
source "../../common/init.sh"

get https://lttng.org/files/urcu/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
