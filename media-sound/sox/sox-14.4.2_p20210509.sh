#!/bin/sh
source "../../common/init.sh"

# We take a snapshot because of the huge number of security
# and other fixes since the release of 14.4.2.
# Recommend mirroring the snapshot; unclear if they are stable URIs.
COMMIT="42b3557e13e0fe01a83465b672d89faddbe65f49"
MY_P="sox-code-${COMMIT}"
get https://dev.gentoo.org/~fordfrog/distfiles/${MY_P}.zip "${P}".zip
#get https://download.sourceforge.net/${PN}/${P}.tar.gz

acheck

cd "${S}" || exit

# gentoo bug #386027
sed -i -e 's|CFLAGS="-g"|CFLAGS="$CFLAGS -g"|' configure.ac

aautoreconf

cd "${T}" || exit

importpkg vorbis media-sound/gsm media-sound/lame libpng sys-devel/libtool sys-apps/file media-libs/libid3tag media-libs/opencore-amr media-libs/libmad media-sound/twolame media-libs/libsndfile media-sound/wavpack media-libs/alsa-lib

doconf --enable-alsa --enable-amrnb --enable-amrwb --with-lame --enable-flac --with-id3tag --with-ladspa --with-mad --with-magic --enable-openmp --enable-oggvorbis --enable-opus --with-png --enable-sndfile --with-twolame --enable-wavpack --enable-formats=dyn --with-distro=Azusa
# TODO enable-pulseaudio ?

make
make install DESTDIR="${D}"

finalize
