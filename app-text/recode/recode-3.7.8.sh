#!/bin/sh
source "../../common/init.sh"

get https://github.com/rrthomas/recode/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
