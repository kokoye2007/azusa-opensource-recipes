#!/bin/sh
source "../../common/init.sh"

get https://github.com/libevent/libevent/releases/download/release-"${PV}"-stable/"${P}"-stable.tar.gz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
