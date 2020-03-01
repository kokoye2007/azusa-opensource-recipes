#!/bin/sh
source "../../common/init.sh"

# change PN during get so we use the same file as qemu
PN=qemu
get https://download.qemu.org/qemu-${PV}.tar.xz
PN=qemu-console
acheck

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

importpkg sys-fs/udev
export CFLAGS="$CPPFLAGS"

callconf --prefix="/pkg/main/${PKG}.core.${PVR}" --interp-prefix="/pkg/main/${PKG}.mod.${PV}.%M.${OS}.${ARCH}" --mandir="/pkg/main/${PKG}.doc.${PVR}/man" --docdir="/pkg/main/${PKG}.doc.${PVR}" --libdir=lib$LIB_SUFFIX --sysconfdir=/etc \
	--audio-drv-list= --enable-malloc-trim --with-pkgversion=-console \
	--disable-sdl --disable-sdl-image --disable-xkbcommon --disable-gtk --disable-vte --disable-xen --disable-xen-pci-passthrough --disable-opengl --disable-virglrenderer

make -j8
make install DESTDIR="${D}"

finalize
