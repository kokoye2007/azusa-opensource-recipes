#!/bin/sh
source "../../common/init.sh"

get https://github.com/pjsip/${PN}/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

importpkg media-libs/speex media-libs/speexdsp media-sound/gsm net-libs/libsrtp

CONFIG=(
	--enable-shared
	--with-external-srtp
	--enable-sound
	--enable-opencore-amr
	--enable-epoll
	--enable-opus
	--enable-ext-sound
	--enable-libsamplerate
	--enable-resample-dll
	--enable-resample
	--enable-silk
	--enable-speex-aec
	--enable-ssl
	--with-external-gsm
	--with-external-pa
	--with-external-speex
)

doconf "${CONFIG[@]}" || /bin/bash -i

make
make install DESTDIR="${D}"

finalize
