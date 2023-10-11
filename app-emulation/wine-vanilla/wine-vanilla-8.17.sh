#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN%%-*}"
MY_P="${MY_PN}-${PV}"

get https://dl.winehq.org/wine/source/8.x/${MY_P}.tar.xz
acheck

importpkg X opengl osmesa net-libs/libpcap net-print/cups media-libs/openal net-nds/openldap #OpenCL

cd "${T}"

#configure: OpenCL 64-bit development files not found, OpenCL won't be supported.
#configure: libsane 64-bit development files not found, scanners won't be supported.
#configure: libv4l2 64-bit development files not found.
#configure: libgphoto2 64-bit development files not found, digital cameras won't be supported.
#configure: libgphoto2_port 64-bit development files not found, digital cameras won't be auto-detected.
#configure: OSS sound system found but too old (OSSv4 needed), OSS won't be supported.
#configure: libcapi20 64-bit development files not found, ISDN won't be supported.
#configure: libvulkan and libMoltenVK 64-bit development files not found, Vulkan won't be supported.

CONFOPTS=(
	--with-alsa
	#--with-capi
	--with-cups
	--with-dbus
	--with-fontconfig
	--with-gnutls
	--enable-mshtml
	--with-gphoto
	--with-gssapi
	--with-gstreamer
	--enable-hal
	--with-ldap
	--with-mingw
	#--with-mscoree
	--with-netapi
	--with-gettext
	--with-openal
	#--with-opencl
	--with-opengl
	--with-osmesa
	#--with-pcap # FIXME
	--with-pulse
	--with-pthread
	#--with-sane
	--with-sdl
	--with-freetype
	--with-udev
	--with-unwind
	--with-usb
	#--with-v4l2
	#--with-vulkan
	--with-x
	--with-xfixes
	--with-xcomposite
	--with-xinerama
)

case "$ARCH" in
	amd64)
		doconf "${CONFOPTS[@]}" --enable-win64 --program-suffix=64

		make -j8
		make install DESTDIR="${D}"
		;;
	*)
		doconf "${CONFOPTS[@]}"

		make -j8
		make install DESTDIR="${D}"
		;;
esac

finalize
