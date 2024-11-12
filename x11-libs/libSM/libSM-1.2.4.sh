#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/lib/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-apps/util-linux

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
