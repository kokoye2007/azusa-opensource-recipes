#!/bin/sh
source "../../common/init.sh"

get https://download.qemu.org/${P}.tar.xz
acheck

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

importpkg media-libs/alsa-lib sys-fs/udev media-libs/libepoxy egl dev-libs/libaio sys-libs/libcap-ng
export CFLAGS="$CPPFLAGS"

CONFOPTS=(
	--prefix="/pkg/main/${PKG}.core.${PVRF}"
	--interp-prefix="/pkg/main/${PKG}.mod.${PVRF}.%M"
	# The value of the 'mandir' option must be a subdir of the prefix
	--mandir="/pkg/main/${PKG}.core.${PVRF}/share/man"
	--docdir="/pkg/main/${PKG}.doc.${PVRF}"
	--libdir=lib$LIB_SUFFIX

	--with-pkgversion="-azusa"
	--extra-ldflags="-Wl,--as-needed"

	--disable-xen
	--enable-user
	--enable-system
	--enable-linux-user
	--disable-bsd-user

	--enable-modules
	--enable-module-upgrades

	--enable-virtfs
	--enable-virtiofsd
	--enable-tools
	--enable-curl

	--disable-guest-agent
	--disable-werror
	--disable-gcrypt

	--enable-plugins
	--enable-attr
	--enable-bzip2
	--enable-cap-ng
	--enable-gnutls
	--enable-nettle
	--enable-membarrier
	--enable-kvm
	#--enable-netmap
	--enable-tpm
	--enable-jemalloc
	--enable-linux-aio
	#--enable-linux-io-uring
	--enable-vnc-jpeg
	--enable-vnc-png
	--enable-seccomp
	--enable-usb-redir
	--enable-vhost-net
	--enable-vhost-vsock
	--enable-vhost-crypto
	--enable-vhost-kernel
	--enable-vhost-user
	--enable-vhost-user-fs
	--enable-vhost-vdpa
	--enable-crypto-afalg
	--enable-vnc
	--enable-libxml2
	--audio-drv-list="alsa,pa,sdl"
	--enable-libpmem
	--enable-spice
	--enable-rbd
	--enable-opengl
	--enable-virglrenderer
	--enable-sdl
	--enable-sdl-image
	--audio-drv-list=alsa,pa
	--enable-malloc-trim
	--enable-xkbcommon
	--enable-gtk
	--enable-vte
)

callconf "${CONFOPTS[@]}"

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
