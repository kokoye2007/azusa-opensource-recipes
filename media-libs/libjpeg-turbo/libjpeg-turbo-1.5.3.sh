#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/libjpeg-turbo/files/${PV}/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
