#!/bin/sh
source "../../common/init.sh"

get https://download.qemu.org/${P}.tar.xz
acheck

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

importpkg media-libs/alsa-lib sys-fs/udev
export CFLAGS="$CPPFLAGS"

callconf --prefix="/pkg/main/${PKG}.core.${PVRF}" --interp-prefix="/pkg/main/${PKG}.mod.${PVRF}.%M" --mandir="/pkg/main/${PKG}.doc.${PVRF}/man" --docdir="/pkg/main/${PKG}.doc.${PVRF}" --libdir=lib$LIB_SUFFIX --sysconfdir=/etc \
	--audio-drv-list=alsa --enable-malloc-trim \
	--enable-sdl --enable-sdl-image --enable-xkbcommon --enable-gtk --enable-vte --enable-opengl --enable-virglrenderer

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
