#!/bin/sh
source "../../common/init.sh"

get http://files.itstool.org/itstool/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
