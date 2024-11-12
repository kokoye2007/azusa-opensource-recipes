#!/bin/sh
source "../../common/init.sh"

get http://caca.zoy.org/files/libcaca/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-java --disable-static --disable-doc

make
make install DESTDIR="${D}"

finalize
