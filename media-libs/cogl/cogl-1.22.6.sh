#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/"${P}".tar.xz
acheck

cd "${S}" || exit
apatch "$FILESDIR/${P}"-*.patch
aautoreconf

cd "${T}" || exit

importpkg dev-libs/wayland media-libs/mesa

export CFLAGS="${CPPFLAGS} -O2"

doconf --disable-examples-install --disable-maintainer-flags --enable-cairo --enable-gdk-pixbuf --enable-glib --enable-introspection --enable-gles1 --enable-gles2 --enable-{kms,wayland,xlib}-egl-platform --enable-wayland-egl-server

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
