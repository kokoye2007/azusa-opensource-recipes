#!/bin/sh
source "../../common/init.sh"

get https://www.imagemagick.org/download/releases/ImageMagick-${PV}.tar.xz
acheck

cd "${T}"

importpkg X sys-devel/libtool app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd media-libs/libjpeg-turbo sci-libs/fftw media-libs/tiff app-arch/zstd

doconf --sysconfdir=/etc --enable-hdri --with-modules --disable-static --with-fftw=yes --with-jxl=yes

# required during build
ln -s /pkg/main/sys-devel.libtool.libs/lib$LIB_SUFFIX/libltdl.la /usr/lib$LIB_SUFFIX/libltdl.la

make
make install DESTDIR="${D}"

finalize
