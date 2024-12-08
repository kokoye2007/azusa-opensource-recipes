#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.bz2
acheck

cd "${T}"

importpkg net-dns/avahi dev-libs/libpcre2 media-libs/opus sys-libs/libcap

mesonargs=(
	-Ddbus=enabled
	-Davahi=enabled
	-Dexamples=disabled
	-Dinstalled_tests=disabled
	-Dsystemd=disabled
	-Dlogind-provider=libelogind
	-Dpipewire-alsa=enabled
	-Dspa-plugins=enabled
	-Dalsa=enabled
	-Dcompress-offload=disabled
	-Daudiomixer=enabled
	-Daudioconvert=enabled
	# todo bluetooth
	-Dcontrol=enabled
	-Daudiotestsrc=enabled
	-Dffmpeg=disabled
	-Dpipewire-jack=enabled
	-Dsupport=enabled # Miscellaneous/common plugins, such as null sink
	-Devl=disabled
	-Dtest=disabled
	-Dv4l2=enabled
	-Dvideoconvert=enabled # Matches upstream
	-Dvideotestsrc=enabled # Matches upstream
	-Dvolume=enabled # Matches upstream
	-Dvulkan=disabled # Uses pre-compiled Vulkan compute shader to provide a CGI video source (dev thing; disabled by upstream)
	-Dudev=enabled
	#-Dudevrulesdir=
	-Dsdl2=disabled
	-Dlibmysofa=disabled
	-Dsession-managers="[]"

	-Dx11=enabled
	-Dx11-xfixes=enabled
	-Dlibcanberra=enabled

	-Dsnap=disabled
	-Dgsettings-pulse-schema=enabled

	-Dreadline=disabled # TODO fails compile
)

domeson "${mesonargs[@]}"

finalize
