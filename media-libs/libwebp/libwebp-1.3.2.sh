#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${P}.tar.gz
acheck

cd "${T}"

importpkg media-libs/libsdl2 media-libs/libjpeg-turbo media-libs/tiff media-libs/giflib media-libs/freeglut

# make thing work
export LDFLAGS="${LDFLAGS} -L${T}/src/.libs"

doconf #--enable-everything

make V=1
make install DESTDIR="${D}"

finalize
