#!/bin/sh
source "../../common/init.sh"

get https://scummvm.org/frs/scummvm/${PV}/${P}.tar.xz
acheck

importpkg X readline media-libs/sdl2-net media-libs/libtheora media-libs/libogg media-libs/libvorbis media-libs/alsa-lib app-accessibility/speech-dispatcher media-libs/libmpeg2 libjpeg media-libs/flac media-libs/libmad media-libs/faad2 media-libs/a52dec

export CPPFLAGS="${CPPFLAGS} -I/pkg/main/media-libs.sdl2-net.dev/include/SDL2"
#export LDFLAGS="${LDFLAGS} -Wl,-z,noexecstack"

cd "${S}"

# -g isn't needed for nasm here
sed -i \
	-e '/NASMFLAGS/ s/-g//' \
	configure
sed -i \
	-e '/INSTALL.*doc/d' \
	-e '/INSTALL.*\/pixmaps/d' \
	-e 's/-s //' \
	ports.mk

cd "${T}"

CONFOPTS=(
	--backend=sdl
	--enable-verbose-build
	--opengl-mode=auto

	--enable-plugins
	--default-dynamic

	--enable-a52
	--enable-faad
	--enable-alsa
	--enable-release-mode
	--enable-flac
	--enable-jpeg
	--enable-lua
	--enable-mad
	--enable-mpeg2
	--enable-sdlnet
	--enable-png
	--enable-tts
	--enable-theoradec
	--enable-freetype2
	#--enable-all-engines
	--enable-vorbis
	--enable-zlib
	#--enable-nasm
)

SDL_CONFIG="sdl2-config" doconflight "${CONFOPTS[@]}"

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
