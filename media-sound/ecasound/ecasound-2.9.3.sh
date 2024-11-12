#!/bin/sh
source "../../common/init.sh"

get https://ecasound.seul.org/download/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg ncurses media-libs/audiofile media-libs/alsa-lib media-libs/libsamplerate

CONFIG=(
	--disable-arts
	--enable-shared
	--enable-sys-readline
	--with-largefile
	--enable-alsa
	--enable-audiofile
	#--enable-jack
	--enable-libsamplerate
	--enable-liblilv
	--enable-ncurses
	--enable-liboil
	--enable-liblo
	--disable-oss
	#--enable-pyecasound
	#--enable-rubyecasound
	--enable-sndfile
)

doconf "${CONFIG[@]}"

make
make install DESTDIR="${D}"

finalize
