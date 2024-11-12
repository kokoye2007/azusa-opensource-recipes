#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/iodbc/"${P}".tar.gz

cd "${T}" || exit

doconf --with-iodbc-inidir=/etc/iodbc --disable-libodbc --disable-static

make
make install DESTDIR="${D}"

finalize
