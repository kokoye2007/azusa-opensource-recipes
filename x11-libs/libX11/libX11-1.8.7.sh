#!/bin/sh
source "../../common/init.sh"

get https://xorg.freedesktop.org/archive/individual/lib/"${P}".tar.xz
acheck

cd "${T}" || exit

#importpkg dev-libs/libbsd

doconf --enable-ipv6 --without-fop --localstatedir=/var --disable-silent-rules

make
make install DESTDIR="${D}"

finalize
