#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/xdvi/${P}.tar.gz
acheck

cd "${T}"

importpkg x11-base/xorg-proto x11-libs/libX11 x11-libs/libXext x11-libs/libXaw x11-libs/libXpm

export CFLAGS="${CPPFLAGS} -O2"

doconf --with-x --with-system-freetype2 --with-system-kpathsea --disable-native-texlive-build --with-xdvi-x-toolkit=xaw --x-includes=/pkg/main/azusa.symlinks.core/full/include --x-libraries=/pkg/main/azusa.symlinks.core/full/lib$LIB_SUFFIX

make
make install DESTDIR="${D}"

finalize
