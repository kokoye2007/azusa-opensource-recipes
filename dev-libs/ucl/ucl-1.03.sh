#!/bin/sh
source "../../common/init.sh"

get http://www.oberhumer.com/opensource/ucl/download/"${P}".tar.gz
acheck

cd "${T}" || exit

doconflight --enable-shared CFLAGS="-std=c90 -O2"

make
make install DESTDIR="${D}"

finalize
