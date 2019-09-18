#!/bin/sh
source "../../common/init.sh"

get https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

ln -snfv enchant-2 "${D}/pkg/main/${PKG}.dev.${PVR}/include/enchant"
ln -snfv libenchant-2.so "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/libenchant.so"
ln -snfv enchant-2.pc "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/pkgconfig/enchant.pc"
ln -snfv enchant-2 "${D}/pkg/main/${PKG}.core.${PVR}/bin/enchant"

finalize
