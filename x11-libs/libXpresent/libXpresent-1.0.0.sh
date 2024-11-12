#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/lib/"${P}".tar.bz2
acheck

importpkg x11-libs/libXext x11-libs/libXfixes x11-libs/libXrandr x11-libs/libXrender

cd "${T}" || exit

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
