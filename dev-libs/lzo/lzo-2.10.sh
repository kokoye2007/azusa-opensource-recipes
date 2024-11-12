#!/bin/sh
source "../../common/init.sh"

get http://www.oberhumer.com/opensource/lzo/download/"${P}".tar.gz

cd "${T}" || exit

doconf --enable-shared --disable-static

make
make install DESTDIR="${D}"

finalize
