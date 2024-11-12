#!/bin/sh
source "../../common/init.sh"

get https://www.openprinting.org/download/cups-filters/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg libjpeg libtiff-4 net-dns/avahi

# TODO enable avahi
doconf --sysconfdir=/etc --localstatedir=/var --without-rcdir --disable-static --disable-avahi

make
make install DESTDIR="${D}"

finalize
