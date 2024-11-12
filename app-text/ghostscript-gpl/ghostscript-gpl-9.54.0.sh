#!/bin/sh
source "../../common/init.sh"

get https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs"${PV/./}"/ghostscript-"${PV}".tar.xz
get https://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz
get https://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz
acheck

cd "${S}" || exit

rm -rf cups/libs freetype jbig2dec lcms2mt jpeg libpng openjpeg zlib tiff openjpeg

importpkg zlib libjpeg libpng lcms2 media-libs/jbig2dec

# needs libz ...
ln -snfv /pkg/main/sys-libs.zlib.libs/lib"$LIB_SUFFIX"/libz.so* /usr/lib"$LIB_SUFFIX"/

doconf --disable-compile-inits --enable-dynamic --with-system-libtiff

make
make so
make install DESTDIR="${D}"
make soinstall DESTDIR="${D}"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/include/ghostscript"
install -v -m644 base/*.h "${D}/pkg/main/${PKG}.dev.${PVRF}/include/ghostscript"
ln -sfvn ghostscript "${D}/pkg/main/${PKG}.dev.${PVRF}/include/ps"

mkdir -p "${D}/pkg/main/${PKG}.fonts.${PVRF}"
mv -v "${CHPATH}/fonts" "${D}/pkg/main/${PKG}.fonts.${PVRF}"

finalize
