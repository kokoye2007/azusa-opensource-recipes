#!/bin/sh
source "../../common/init.sh"

get https://download.qemu.org/"${P}".tar.xz
acheck

cd "${S}" || exit

apatch "$FILESDIR/qemu-8.0.0-fix-syscalls.patch"

cd "${T}" || exit

# --audio-drv-list=oss,alsa,sdl,pa

importpkg media-libs/alsa-lib sys-fs/udev media-libs/libepoxy egl dev-libs/libaio sys-libs/libcap-ng app-arch/bzip2 dev-libs/jemalloc dev-libs/libgcrypt net-libs/libssh2 dev-libs/lzo app-arch/snappy sys-process/numactl zlib dev-libs/pmdk sys-block/ndctl sys-libs/liburing gdk-pixbuf-2.0 dev-libs/capstone
# sys-kernel/linux
export CPPFLAGS="${CPPFLAGS} -isystem /pkg/main/sys-kernel.linux.dev/include"
export CFLAGS="$CPPFLAGS"

CONFOPTS=(
	--prefix="/pkg/main/${PKG}.core.${PVRF}"
	--interp-prefix="/pkg/main/${PKG}.mod.%M.${PVRF}"
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
	--enable-tools
	--enable-curl

	--disable-guest-agent
	--disable-werror
	--disable-gcrypt
	--enable-malloc=jemalloc

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
	--enable-slirp
	#--enable-linux-io-uring
	--enable-vnc-jpeg
	--enable-seccomp
	--enable-usb-redir
	--enable-vhost-net
	--enable-vhost-crypto
	--enable-vhost-kernel
	--enable-vhost-user
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
)

callconf "${CONFOPTS[@]}"

make -j"$NPROC" || /bin/bash -i
make install DESTDIR="${D}"

finalize
