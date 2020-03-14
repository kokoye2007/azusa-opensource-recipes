#!/bin/sh
source "../../common/init.sh"

get https://download.gimp.org/pub/gegl/0.4/${P}.tar.bz2
acheck

cd "${T}"

importpkg libjpeg

# make asciidoc work
ln -snfT /pkg/main/app-text.asciidoc.core/etc/asciidoc /etc/asciidoc

doconf

make
make install DESTDIR="${D}"

#mkdir -p "${D}/pkg/main/${PKG}.doc.${PVR}/html/images"

#install -v -m644 docs/*.{css,html} "${D}/pkg/main/${PKG}.doc.${PVR}/html"
#install -v -m644 docs/images/*.{png,ico,svg} "${D}/pkg/main/${PKG}.doc.${PVR}/html/images"

finalize
