#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/cairo/cairo/-/archive/${PV}/cairo-${PV}.tar.bz2
acheck

cd "${T}"

importpkg zlib

doconf --disable-static -with-x --enable-tee --enable-xlib --enable-xlib-xrender --enable-xcb --enable-xcb-shm --enable-gobject --enable-gl --enable-svg --enable-ft --enable-interpreter --enable-pdf --enable-png --enable-ps --enable-script --disable-drm --disable-directfb --disable-gallium --disable-qt --disable-vg --disable-xlib-xcb --enable-full-testing

make
make install DESTDIR="${D}"

finalize
