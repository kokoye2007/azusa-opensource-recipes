#!/bin/sh
source "../../common/init.sh"

MY_P="Argyll_V${PV}"
get http://www.argyllcms.com/${MY_P}_src.zip
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
