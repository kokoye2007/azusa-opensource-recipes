#!/bin/sh
source "../../common/init.sh"

MY_P="Audacity-${PV}"
get https://github.com/audacity/audacity/archive/${MY_P}.tar.gz
get https://dev.gentoo.org/~fordfrog/distfiles/${PN}-manual-${PV}.zip
acheck

importpkg zlib

cd "${T}"

CMAKEOPTS=(
	-Daudacity_lib_preference=system
	-Daudacity_use_expat=system
	-Daudacity_use_ffmpeg=loaded
	-Daudacity_use_flac=system
	-Daudacity_use_id3tag=system
	-Daudacity_use_ladspa=ON
	-Daudacity_use_lame=system
	-Daudacity_use_lv2=system
	-Daudacity_use_mad=system
	-Daudacity_use_midi=system
	-Daudacity_use_nyquist=local
	-Daudacity_use_ogg=system
	-Daudacity_use_pa_alsa=ON
	-Daudacity_use_pa_jack=linked
	-Daudacity_use_pa_oss=OFF
	-Daudacity_use_portaudio=local
	-Daudacity_use_portmixer=local
	-Daudacity_use_portsmf=local
	-Daudacity_use_sbsms=local
	-Daudacity_use_sndfile=system
	-Daudacity_use_soundtouch=system
	-Daudacity_use_soxr=system
	-Daudacity_use_twolame=system
	-Daudacity_use_vamp=system
	-Daudacity_use_vorbis=system
	-Daudacity_use_vst=ON
	-Daudacity_use_wxwidgets=system
)

docmake "${CMAKEOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
