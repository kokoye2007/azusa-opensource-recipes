#!/bin/sh
source "../../common/init.sh"

get ftp://xmlsoft.org/libxml2/${P}.tar.gz
acheck

cd "${T}"

importpkg python-2.7 icu-uc

doconf --disable-maintainer-mode --disable-static --with-icu

make
make install DESTDIR="${D}"

# fix for ffmpeg (and probably others)
ln -v -s . "${D}/pkg/main/${PKG}.dev.${PVR}/include/libxml2/libxml2"

finalize
