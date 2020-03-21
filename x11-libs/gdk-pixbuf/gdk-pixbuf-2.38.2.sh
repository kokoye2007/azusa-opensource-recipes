#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.38/${P}.tar.xz

cd "${T}"

importpkg media-libs/libpng media-libs/libjpeg-turbo

# TODO fix man building (xsltproc fails)
meson --prefix="/pkg/main/${PKG}.core.${PVRF}" "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

# /root/gdk-pixbuf-2.38.2/build/gdk-pixbuf/loaders.cache
#cp -v gdk-pixbuf/loaders.cache "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"/gdk-pixbuf-*/2.*/loaders.cache
#"${D}/pkg/main/${PKG}.core.${PVRF}/bin/gdk-pixbuf-query-loaders" > "${D}/pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX"/gdk-pixbuf-*/2.*/loaders.cache

echo "Generate pixbuf loaders.cache"
echo "Output to: ${D}/pkg/main/${PKG}.core.${PVRF}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"

"${D}/pkg/main/${PKG}.core.${PVRF}/bin/gdk-pixbuf-query-loaders" > "${D}/pkg/main/${PKG}.core.${PVRF}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"

finalize
