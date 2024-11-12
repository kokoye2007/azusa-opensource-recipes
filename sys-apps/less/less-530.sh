#!/bin/sh
source "../../common/init.sh"

get http://www.greenwoodsoftware.com/less/"${P}".tar.gz

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
