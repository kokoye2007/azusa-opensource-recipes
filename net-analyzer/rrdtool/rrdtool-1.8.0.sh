#!/bin/sh
source "../../common/init.sh"

get https://github.com/oetiker/rrdtool-1.x/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg libxcrypt

doconf --disable-perl --disable-ruby

make
make install DESTDIR="${D}"

finalize
