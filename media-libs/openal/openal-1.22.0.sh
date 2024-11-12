#!/bin/sh
source "../../common/init.sh"

MY_P="${PN}-soft-${PV}"
get https://www.openal-soft.org/openal-releases/"${MY_P}".tar.bz2 "${P}.tar.bz2"
acheck

importpkg media-libs/alsa-lib media-sound/pulseaudio media-libs/libsdl2 sys-libs/zlib

cd "${T}" || exit

CMAKEOPTS=(
	-DALSOFT_REQUIRE_ALSA=ON
	-DALSOFT_REQUIRE_COREAUDIO=OFF
	-DALSOFT_REQUIRE_JACK=OFF
	-DALSOFT_REQUIRE_OSS=OFF
	-DALSOFT_REQUIRE_PORTAUDIO=OFF
	-DALSOFT_REQUIRE_PULSEAUDIO=ON
	-DALSOFT_REQUIRE_SDL2=ON
	-DALSOFT_UTILS=ON
	-DALSOFT_NO_CONFIG_UTIL=OFF
	-DALSOFT_EXAMPLES=OFF # avoid ffmpeg dep
	-DALSOFT_CPUEXT_SSE4_1=OFF # TODO if this is on, is the runtime able to run on order cpu (runtime switch?)

	-DSDL2_INCLUDE_DIR=/pkg/main/media-libs.libsdl2.dev/include
)

# -DALSOFT_CPUEXT_SSE= -DALSOFT_CPUEXT_SSE2= -DALSOFT_CPUEXT_SSE4_1= -DALSOFT_CPUEXT_NEON=

docmake "${CMAKEOPTS[@]}"

finalize
