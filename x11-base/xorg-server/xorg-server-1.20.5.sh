#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/xserver/${P}.tar.bz2
acheck

cd "${T}"

doconf --enable-glamor --enable-suid-wrapper --disable-systemd-logind --with-xkb-output=/var/lib/xkb --enable-dmx --enable-kdrive --enable-install-setuid

make
make install DESTDIR="${D}"

# move xorg modules
mkdir -vp "${D}/pkg/main/${PKG}.mod.${PVR}/xorg"
mv -vT "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/xorg/modules" "${D}/pkg/main/${PKG}.mod.${PVR}/lib$LIB_SUFFIX/xorg/modules"
ln -snfTv "/pkg/main/${PKG}-modules.libs.${PVR}/lib$LIB_SUFFIX/xorg/modules" "${D}/pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX/xorg/modules"

finalize
