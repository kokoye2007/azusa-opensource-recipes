#!/bin/sh
source "../../common/init.sh"

get http://opensource.yubico.com/yubico-c/releases/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
