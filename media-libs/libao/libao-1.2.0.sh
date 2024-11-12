#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/ao/"${P}".tar.gz

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
