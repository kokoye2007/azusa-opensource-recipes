#!/bin/sh
source "../../common/init.sh"

get mirror://sourceforge/judy/Judy-"${PV}".tar.gz
acheck

cd "${S}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
