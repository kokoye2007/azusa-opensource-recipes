#!/bin/sh
source "../../common/init.sh"

get mirror://sourceforge/judy/Judy-${PV}.tar.gz
acheck

cd "${S}"

doconf

make
make install DESTDIR="${D}"

finalize
