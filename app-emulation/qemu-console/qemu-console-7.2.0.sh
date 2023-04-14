#!/bin/sh
source "../../common/init.sh"

# change PN during get so we use the same file as qemu
PN=qemu
get https://download.qemu.org/qemu-${PV}.tar.xz
PN=qemu-console
acheck

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

importpkg sys-fs/udev zlib app-arch/bzip2 app-arch/snappy sys-process/numactl dev-libs/pmdk sys-block/ndctl sys-libs/liburing
export CFLAGS="$CPPFLAGS"

callconf --prefix="/pkg/main/${PKG}.core.${PVRF}" --interp-prefix="/pkg/main/${PKG}.mod.${PV}.%M.${OS}.${ARCH}" --mandir="/pkg/main/${PKG}.doc.${PVRF}/man" --docdir="/pkg/main/${PKG}.doc.${PVRF}" --libdir=lib$LIB_SUFFIX --sysconfdir=/etc \
	--audio-drv-list= --enable-malloc-trim --with-pkgversion=-console --with-suffix=qemu-console \
	--disable-sdl --disable-sdl-image --disable-xkbcommon --disable-gtk --disable-vte --disable-xen --disable-xen-pci-passthrough --disable-opengl --disable-virglrenderer \
	--disable-pa --disable-oss --disable-alsa --disable-jack --enable-bzip2 --enable-snappy --enable-rbd

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
