#!/bin/sh
source "../../common/init.sh"
inherit waf

get https://github.com/mpv-player/mpv/archive/v${PV}.tar.gz ${P}.tar.gz
cd "${S}"
get https://waf.io/waf-2.0.20
mv waf-2.0.20 waf
chmod +x waf
acheck

importpkg libjpeg dev-lang/lua

cd "${T}"

CONFOPTS=(
	--disable-libmpv-static
	--disable-static-build
	--disable-debug-build
	--enable-html-build
	--disable-pdf-build
	--enable-manpage-build
	--enable-cplugins

	--enable-iconv
	--disable-lua
	#--enable-lua
	#--lua="lua-5"
	#--enable-javascript # mujs
	--enable-zlib
	#--enable-libbluray # libbluray
	#--enable-dvdnav
	--enable-cdda
	#--enable-uchardet
	#--enable-rubberband
	--enable-lcms2
	--disable-vapoursynth
	--enable-libarchive

	--enable-libavdevice

	--enable-sdl2
	--enable-pulse
	#--enable-openal
	--disable-opensles
	--enable-alsa

	# video
	--enable-drm
	#--enable-gbm
	--enable-wayland-scanner
	--enable-wayland-protocols
	--enable-wayland
	--enable-x11
	--enable-xv
	#--enable-gl-x11
	--enable-egl-x11
	#--enable-egl-drm
	--enable-gl-wayland
	--enable-vdpau
	#--enable-vdpau-gl-x11
	--enable-vaapi
	--enable-vaapi-x11
	--enable-vaapi-wayland
	#--enable-vaapi-drm
	--enable-caca
	--enable-jpeg
	#--enable-shaderc
	#--enable-libplacebo
	#--enable-rpi
	#--enable-plain-gl
	#--enable-vulkan
	--enable-sdl2-gamepad

	#--enable-cuda-hwaccel
	#--enable-cuda-interop

	# TV
	--enable-dvbin

	# misc
	#--enable-zimg


	--disable-android
	--disable-egl-android
	--disable-uwp
	--disable-audiounit
	--disable-macos-media-player
	--disable-wasapi
	--disable-ios-gl
	--disable-macos-touchbar
	--disable-macos-cocoa-cb
	--disable-tvos
	--disable-egl-angle-win32

	--disable-build-date
)

dowaf "${CONFOPTS[@]}"

finalize
