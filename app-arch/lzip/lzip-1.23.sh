#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/lzip/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
