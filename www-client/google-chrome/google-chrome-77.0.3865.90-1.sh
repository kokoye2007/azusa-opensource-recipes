#!/bin/sh
source "../../common/init.sh"

# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_76.0.3809.132-1_amd64.deb
get https://dl.google.com/linux/chrome/deb/pool/main/g/${PN}-stable/${PN}-stable_${PV}_amd64.deb
acheck

ar x "${PN}-stable_${PV}_amd64.deb"
tar xvf data.tar.xz

rm -r etc

# todo ... a lot of stuff...

# move language packs to separate packages (+symlinks)

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
mv usr/* "${D}/pkg/main/${PKG}.core.${PVR}"
mv opt/google/chrome "${D}/pkg/main/${PKG}.core.${PVR}"

# set suid bit on chrome-sandbox, and limit to +x
chmod -v 04711 "${D}/pkg/main/${PKG}.core.${PVR}/chrome/chrome-sandbox"

cd "${D}/pkg/main/${PKG}.core.${PVR}"
rm bin/google-chrome-stable

ln -s /pkg/main/${PKG}.core.${PVR}/chrome/google-chrome bin/google-chrome-stable

# ...

finalize
