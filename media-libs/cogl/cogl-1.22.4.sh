#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/${P}.tar.xz

cd "${T}"

export LD_LIBRARY_PATH=/pkg/main/dev-libs.glib.core/lib$LIB_SUFFIX

doconf --enable-gles1 --enable-gles2 --enable-{kms,wayland,xlib}-egl-platform --enable-wayland-egl-server

make
make install DESTDIR="${D}"

finalize
