#!/bin/sh
source "../../common/init.sh"

get https://download.qemu.org/${P}.tar.xz

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

callconf --prefix="/pkg/main/${PKG}.core.${PVR}" --interp-prefix="/pkg/main/${PKG}.qemu-%M.${PVR}" --mandir="/pkg/main/${PKG}.doc.${PVR}/man" --docdir="/pkg/main/${PKG}.doc.${PVR}" --libdir=lib$LIB_SUFFIX --sysconfdir=/etc \
	--audio-drv-list=alsa --enable-malloc-trim

make -j8
make install DESTDIR="${D}"

finalize
