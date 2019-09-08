#!/bin/sh
source "../../common/init.sh"

# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_76.0.3809.132-1_amd64.deb
get https://dl.google.com/linux/chrome/deb/pool/main/g/${PN}-stable/${PN}-stable_${PV}_amd64.deb

ar x "${P}_amd64.deb"
tar xvf data.tar.xz

rm -r etc usr/share/menu
mv usr/share/doc/${PN} usr/share/doc/${P}

# todo ... a lot of stuff...

# move language packs to separate packages (+symlinks)

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
mv usr/* "${D}/pkg/main/${PKG}.core.${PVR}"
mv opt/google/chrome "${D}/pkg/main/${PKG}.core.${PVR}"

# ...

finalize
