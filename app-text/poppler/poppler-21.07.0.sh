#!/bin/sh
source "../../common/init.sh"

get https://poppler.freedesktop.org/${P}.tar.xz
acheck

cd "${T}"

importpkg x11-libs/gtk+ x11-libs/pango x11-libs/cairo zlib dev-libs/atk x11-libs/gdk-pixbuf dev-libs/glib media-libs/freetype libjpeg libpng media-libs/tiff

docmake -DENABLE_UNSTABLE_API_ABI_HEADERS=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include -DICONV_LIBRARIES= -DENABLE_QT5=OFF

make VERBOSE=1
make install DESTDIR="${D}"

finalize
