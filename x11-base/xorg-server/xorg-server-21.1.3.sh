#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/xserver/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg app-arch/bzip2 dev-libs/libbsd sys-libs/libunwind app-arch/xz media-libs/mesa media-libs/libepoxy

# Needed since commit 2a1a96d956f4 ("glamor: Add a function to get the
# driver name via EGL_MESA_query_driver") neglected to add autotools
# support
#export CFLAGS="${CPPFLAGS} -O2 -DGLAMOR_HAS_EGL_QUERY_DRIVER"
# glamor/glamor_egl.c:700:16: error: implicit declaration of function ‘eglGetDisplayDriverName’

export CFLAGS="${CPPFLAGS} -O2"

CONFIGURE=(
	--disable-silent-rules
	--enable-config-udev
	--enable-record
	--enable-xfree86-utils
	--enable-dri
	--enable-dri2
	--enable-dri3
	--enable-glamor
	--enable-glx
	--enable-libdrm
	--with-fontrootdir=/pkg/main/azusa.fontcache.data.symlinks
	--enable-suid-wrapper
	--disable-systemd-logind
	--with-xkb-output=/var/lib/xkb
	--enable-dmx
	--enable-kdrive
	--enable-install-setuid
	--disable-config-hal
	--disable-linux-acpi
	--without-dtrace
	--without-fop
	--with-os-vendor=Azusa
	--with-vendor-name=Azusa
	--with-vendor-name-short=Azusa
	--with-vendor-web=https://www.azusa.jp
	--with-sha1=libcrypto
	--disable-dependency-tracking
)

doconf "${CONFIGURE[@]}"

make || /bin/bash -i
make install DESTDIR="${D}"

# move xorg modules
mkdir -vp "${D}/pkg/main/${PKG}.mod.${PVRF}/lib$LIB_SUFFIX/xorg"
mv -vT "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/xorg/modules" "${D}/pkg/main/${PKG}.mod.${PVRF}/lib$LIB_SUFFIX/xorg/modules"
ln -snfTv "/pkg/main/${PKG}-modules.libs.${PVRF}/lib$LIB_SUFFIX/xorg/modules" "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/xorg/modules"

# move config
mkdir -p "${D}/pkg/main/${PKG}.mod.${PVRF}/share"
mv -vT "${D}/pkg/main/${PKG}.core.${PVRF}/share/X11" "${D}/pkg/main/${PKG}.mod.${PVRF}/share/X11"
ln -snfTv "/pkg/main/${PKG}.mod.${PVRF}/share/X11" "${D}/pkg/main/${PKG}.core.${PVRF}/share/X11"

finalize
