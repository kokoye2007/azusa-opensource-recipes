#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/${P}.tar.xz

cd "${T}"

doconf --enable-gles1 --enable-gles2 --enable-{kms,wayland,xlib}-egl-platform --enable-wayland-egl-server

make
make install DESTDIR="${D}"

finalize
