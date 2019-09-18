#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/aa-project/${P}.tar.gz

cd "${T}"

doconflight --disable-static

make
make install DESTDIR="${D}"

finalize
