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

organize

# because we use icu with libxml2, we need to add the include path to icu in cflags, or dependencies will not build
ICU_PATH=`realpath /pkg/main/dev-libs.icu.dev/include`
echo "Adding ICU path $ICU_PATH"
echo " -> fixing libxml-2.0.pc"
sed -i -re "s#^Cflags:(.*)#Cflags:\\1 -I${ICU_PATH}#" "${D}/pkg/main/${PKG}.dev.${PVR}/pkgconfig/libxml-2.0.pc"
echo " -> fixing libxml2-config.cmake"
sed -i -re "s#^set\\(LIBXML2_INCLUDE_DIRS(.*)\\)#set(LIBXML2_INCLUDE_DIRS\\1 ${ICU_PATH})#" "${D}/pkg/main/${PKG}.dev.${PVR}/cmake/libxml2/libxml2-config.cmake"

archive
