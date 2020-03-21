#!/bin/sh
source "../../common/init.sh"

get http://ftp.debian.org/debian/pool/main/libp/libpaper/libpaper_${PV}.tar.gz
acheck

cd "${P}"

aautoreconf

cd "${T}"

doconf --sysconfdir=/etc --disable-static

make
make install DESTDIR="${D}"

install -vm755 "$FILESDIR/run-parts" "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
