#!/bin/sh
source "../../common/init.sh"

get https://github.com/sahlberg/libnfs/archive/refs/tags/"${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
