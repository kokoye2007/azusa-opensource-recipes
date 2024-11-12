#!/bin/sh
source "../../common/init.sh"

get https://releases.pagure.org/newt/"${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
