#!/bin/sh
source "../../common/init.sh"

get https://download.qemu.org/${P}.tar.xz
acheck

cd "${T}"

# --audio-drv-list=oss,alsa,sdl,pa

importpkg media-libs/alsa-lib sys-fs/udev media-libs/libepoxy egl dev-libs/libaio sys-libs/libcap-ng app-arch/bzip2 dev-libs/jemalloc dev-libs/libgcrypt net-libs/libssh2 dev-libs/lzo app-arch/snappy sys-process/numactl zlib dev-libs/pmdk sys-block/ndctl sys-libs/liburing
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
	--enable-virtiofsd # error: ‘struct statx’ has no member named ‘stx_mnt_id’; did you mean ‘stx_uid’?
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
	--audio-drv-list="alsa,pa,sdl"
	--enable-libpmem
	--enable-spice
	#--enable-rbd # TODO Fix ceph build
	--disable-glusterfs
	--enable-opengl
	--enable-virglrenderer
	--enable-sdl
	--enable-sdl-image
	--audio-drv-list=alsa,pa
	--enable-xkbcommon
	--enable-gtk
	--enable-vte

	# memory
	--enable-jemalloc
	#--enable-malloc-trim
)

callconf "${CONFOPTS[@]}"

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
