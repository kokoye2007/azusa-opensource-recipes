#!/bin/sh
source "../../common/init.sh"

get https://invisible-mirror.net/archives/"${PN}"/"${P}".tgz
acheck

cd "${T}" || exit

doconflight

make
make install DESTDIR="${D}"

finalize
