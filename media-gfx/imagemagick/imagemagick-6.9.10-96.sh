#!/bin/sh
source "../../common/init.sh"

get https://www.imagemagick.org/download/releases/ImageMagick-${PV}.tar.xz
acheck

cd "ImageMagick-${PV}"

patch -p1 <"$FILESDIR/ImageMagick-6.9.10-60-libs_only-1.patch"

cd "${T}"

importpkg sys-devel/libtool app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd

doconf --sysconfdir=/etc --enable-hdri --with-modules --disable-static

# required during build
ln -s /pkg/main/sys-devel.libtool.libs/lib64/libltdl.la /usr/lib64/libltdl.la

make
make install DESTDIR="${D}"

finalize
