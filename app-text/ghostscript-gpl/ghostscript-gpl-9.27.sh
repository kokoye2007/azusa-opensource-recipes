#!/bin/sh
source "../../common/init.sh"

get https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${PV/./}/ghostscript-${PV}.tar.xz
#get https://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz
#get https://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz
acheck

cd "ghostscript-${PV}"

rm -rf freetype lcms2mt jpeg libpng openjpeg zlib

patch -Np1 -i "$FILESDIR/ghostscript-9.27-upstream_fixes-1.patch"

importpkg zlib libjpeg libpng lcms2

# needs libz ...
ln -snfv /pkg/main/sys-libs.zlib.libs/lib$LIB_SUFFIX/libz.so* /usr/lib$LIB_SUFFIX/

doconf --disable-compile-inits --enable-dynamic --with-system-libtiff

make
make so
make install DESTDIR="${D}"
make soinstall DESTDIR="${D}"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVR}/include/ghostscript"
install -v -m644 base/*.h "${D}/pkg/main/${PKG}.dev.${PVR}/include/ghostscript"
ln -sfvn ghostscript "${D}/pkg/main/${PKG}.dev.${PVR}/include/ps"

finalize
