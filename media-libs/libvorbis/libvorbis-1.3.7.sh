#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/vorbis/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
