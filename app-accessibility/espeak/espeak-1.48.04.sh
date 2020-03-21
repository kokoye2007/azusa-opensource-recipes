#!/bin/sh
source "../../common/init.sh"

MY_P="${P}-source"
get https://download.sourceforge.net/${PN}/${MY_P}.zip
acheck

importpkg media-sound/pulseaudio media-libs/portaudio

cd "${S}/src"

apatch "$FILESDIR/${P}-gcc-6-fix.patch"

mv -f portaudio19.h portaudio.h

PATH_ESPEAK_DATA="/pkg/main/${PKG}.data.${PVRF}/espeak-data"

make PREFIX="/pkg/main/${PKG}.core.${PVRF}" AUDIO=runtime CFLAGS="-O2 ${CPPFLAGS}" CXXFLAGS="-O2 ${CPPFLAGS}" PATH_ESPEAK_DATA="$PATH_ESPEAK_DATA" all

echo "Fixing byte order of phoneme data files"
pushd ../platforms/big_endian
make
./espeak-phoneme-data ../../espeak-data . ../../espeak-data/phondata-manifest
cp -f phondata phonindex phontab "../../espeak-data"

popd

make PREFIX="/pkg/main/${PKG}.core.${PVRF}" LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" DESTDIR="${D}" AUDIO=runtime install

cd ..
mkdir -p "${D}$PATH_ESPEAK_DATA"
cp -rv dictsource "${D}$PATH_ESPEAK_DATA"

finalize
